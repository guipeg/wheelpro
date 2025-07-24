-- 🔐 Row-Level Security (RLS)
ALTER TABLE packages ENABLE ROW LEVEL SECURITY;

CREATE POLICY influencer_packages ON packages
  FOR ALL
  USING (influencer_id = current_user_id())
  WITH CHECK (influencer_id = current_user_id());

-- ✅ CHECK constraints
ALTER TABLE users ADD CONSTRAINT check_birthdate_age CHECK (EXTRACT(YEAR FROM age(now(), birthdate)) >= 18);
ALTER TABLE packages ADD CONSTRAINT check_promo_price CHECK (promo_price <= original_price);
ALTER TABLE packages ADD CONSTRAINT check_main_codes_qty CHECK (main_codes_qty >= 0);
ALTER TABLE packages ADD CONSTRAINT check_extra_codes_qty CHECK (extra_codes_qty >= 0);
ALTER TABLE products ADD CONSTRAINT check_stock_non_negative CHECK (stock >= 0);
ALTER TABLE coupons ADD CONSTRAINT check_discount_percent CHECK (discount_percent BETWEEN 0 AND 100);
ALTER TABLE horario_slots ADD CONSTRAINT check_end_time_gt_start CHECK (end_time > start_time);
ALTER TABLE horario_slots ADD CONSTRAINT check_boost_multiplier CHECK (boost_multiplier >= 1.0);

-- ✅ GIN indexes
CREATE INDEX idx_packages_guarantees_gin ON packages USING GIN (guarantees);
CREATE INDEX idx_packages_weights_main_gin ON packages USING GIN (weights_main);
CREATE INDEX idx_packages_weights_extra_gin ON packages USING GIN (weights_extra);
CREATE INDEX idx_spins_probabilities_used_gin ON spins USING GIN (probabilities_used);
CREATE INDEX idx_audit_logs_details_gin ON audit_logs USING GIN (details);

-- ✅ Partitioning (manual)
-- Requer que as tabelas estejam preparadas para particionamento
-- Exemplo para spins:
-- ALTER TABLE spins PARTITION BY RANGE (timestamp);
-- Você deve criar as partições manualmente ou via script SQL separado

-- ✅ Função para validação de probabilidades
CREATE OR REPLACE FUNCTION check_probs_sum(probs jsonb)
RETURNS boolean AS $$
  SELECT COALESCE(SUM(value::numeric), 0) = 100 FROM jsonb_array_elements(probs);
$$ LANGUAGE sql IMMUTABLE STRICT;

-- ✅ Triggers de auditoria
CREATE OR REPLACE FUNCTION log_audit()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs (action_type, user_id, details, timestamp)
  VALUES (TG_RELNAME || '_' || TG_OP, NEW.user_id, row_to_json(NEW), NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ⚠️ IMPORTANTE: certifique-se que as colunas `user_id`, `details` existem nas tabelas

CREATE TRIGGER audit_trigger_spins
AFTER INSERT OR UPDATE ON spins
FOR EACH ROW EXECUTE FUNCTION log_audit();

CREATE TRIGGER audit_trigger_transactions
AFTER INSERT OR UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION log_audit();

CREATE TRIGGER audit_trigger_packages
AFTER UPDATE ON packages
FOR EACH ROW
WHEN (OLD.* IS DISTINCT FROM NEW.*)
EXECUTE FUNCTION log_audit();

CREATE TRIGGER audit_trigger_redeems
AFTER INSERT OR UPDATE ON redeems
FOR EACH ROW EXECUTE FUNCTION log_audit();

-- ✅ Views materializadas

CREATE MATERIALIZED VIEW user_metrics AS
SELECT
  user_id,
  SUM(change_amount) AS total_points,
  COUNT(*) FILTER (WHERE reason = 'SPIN') AS total_spins,
  COUNT(*) FILTER (WHERE reason = 'REDEEM') AS total_redeems
FROM points_histories
GROUP BY user_id;

CREATE INDEX idx_user_metrics_user_id ON user_metrics(user_id);

CREATE MATERIALIZED VIEW margin_reports AS
SELECT
  i.user_id AS influencer_id,
  (SUM(s.points_awarded) / NULLIF(SUM(t.amount_paid), 0)) * 100 AS rtp_real,
  (100 - (SUM(s.points_awarded) / NULLIF(SUM(t.amount_paid), 0)) * 100) AS margin,
  DATE_TRUNC('day', s.timestamp) AS period
FROM spins s
JOIN codes c ON s.code_id = c.id
JOIN transactions t ON c.transaction_id = t.id
JOIN packages p ON t.package_id = p.id
JOIN influencers i ON p.influencer_id = i.user_id
GROUP BY i.user_id, DATE_TRUNC('day', s.timestamp);

CREATE INDEX idx_margin_reports ON margin_reports(influencer_id, period);

CREATE MATERIALIZED VIEW horario_analytics AS
SELECT
  EXTRACT(HOUR FROM timestamp)::int AS hour,
  COUNT(*) AS spin_count,
  AVG(points_awarded) AS avg_points
FROM spins
GROUP BY EXTRACT(HOUR FROM timestamp);

CREATE INDEX idx_horario_analytics_hour ON horario_analytics(hour);
