-- CreateEnum
CREATE TYPE "Role" AS ENUM ('USER', 'INFLUENCER', 'ADMIN');

-- CreateEnum
CREATE TYPE "TransactionStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "CodeType" AS ENUM ('MAIN', 'EXTRA');

-- CreateEnum
CREATE TYPE "PointReason" AS ENUM ('SPIN', 'REDEEM', 'BONUS', 'EXPIRATION');

-- CreateEnum
CREATE TYPE "RedeemStatus" AS ENUM ('PENDING', 'COMPLETED', 'SHIPPED', 'FAILED');

-- CreateEnum
CREATE TYPE "BadgeType" AS ENUM ('FIRST_SPIN', 'HIGH_ROLLER', 'STREAK_MASTER');

-- CreateEnum
CREATE TYPE "ActionType" AS ENUM ('SPIN', 'PURCHASE', 'REDEEM', 'CONFIG_CHANGE');

-- CreateEnum
CREATE TYPE "Period" AS ENUM ('DAILY', 'WEEKLY', 'MONTHLY');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'USER',
    "points_balance" DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    "birthdate" DATE,
    "referral_code" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "influencers" (
    "user_id" UUID NOT NULL,
    "bio" TEXT,
    "social_links" JSONB,
    "follower_count" INTEGER,
    "commission_rate" DECIMAL(5,2) NOT NULL DEFAULT 0.10,

    CONSTRAINT "influencers_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "packages" (
    "id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "original_price" DECIMAL(10,2) NOT NULL,
    "promo_price" DECIMAL(10,2) NOT NULL,
    "main_codes_qty" INTEGER NOT NULL,
    "extra_codes_qty" INTEGER NOT NULL,
    "guarantees" JSONB,
    "weights_main" JSONB,
    "weights_extra" JSONB,
    "influencer_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "packages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transactions" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "package_id" UUID NOT NULL,
    "amount_paid" DECIMAL(10,2) NOT NULL,
    "status" "TransactionStatus" NOT NULL,
    "payment_provider" VARCHAR(50) NOT NULL,
    "transaction_ref" VARCHAR(100) NOT NULL,
    "codes_generated" INTEGER NOT NULL,
    "coupon_id" UUID,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "codes" (
    "id" UUID NOT NULL,
    "transaction_id" UUID NOT NULL,
    "code_value" VARCHAR(20) NOT NULL,
    "type" "CodeType" NOT NULL,
    "weight_override" DECIMAL(5,2),
    "is_used" BOOLEAN NOT NULL DEFAULT false,
    "spin_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "codes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "spins" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "code_id" UUID NOT NULL,
    "points_awarded" DECIMAL(10,2) NOT NULL,
    "seed" VARCHAR(64) NOT NULL,
    "probabilities_used" JSONB NOT NULL,
    "horario_slot_id" UUID,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "spins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "points_histories" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "change_amount" DECIMAL(10,2) NOT NULL,
    "reason" "PointReason" NOT NULL,
    "reference_id" UUID,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "points_histories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "points_required" DECIMAL(10,2) NOT NULL,
    "real_cost" DECIMAL(10,2) NOT NULL,
    "stock" INTEGER NOT NULL DEFAULT 0,
    "influencer_id" UUID,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "redeems" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "product_id" UUID NOT NULL,
    "points_used" DECIMAL(10,2) NOT NULL,
    "status" "RedeemStatus" NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "redeems_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "coupons" (
    "id" UUID NOT NULL,
    "code" VARCHAR(20) NOT NULL,
    "discount_percent" DECIMAL(5,2) NOT NULL,
    "expire_date" DATE NOT NULL,
    "user_id" UUID,
    "package_id" UUID,
    "is_used" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "coupons_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "horario_slots" (
    "id" UUID NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "boost_multiplier" DECIMAL(3,2) NOT NULL DEFAULT 1.00,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "influencer_id" UUID,

    CONSTRAINT "horario_slots_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaigns" (
    "id" UUID NOT NULL,
    "influencer_id" UUID NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE,
    "target_followers" INTEGER,
    "conversion_rate" DECIMAL(5,2),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "streaks" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "streak_count" INTEGER NOT NULL DEFAULT 0,
    "last_activity_date" DATE NOT NULL,
    "bonus_awarded" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "streaks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "badges" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "badge_type" "BadgeType" NOT NULL,
    "awarded_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "badges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" UUID NOT NULL,
    "action_type" "ActionType" NOT NULL,
    "user_id" UUID,
    "details" JSONB NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "margin_configs" (
    "id" UUID NOT NULL,
    "rtp_target" DECIMAL(5,2) NOT NULL DEFAULT 70.00,
    "margin_threshold" DECIMAL(5,2) NOT NULL DEFAULT 30.00,
    "auto_adjust_probs" BOOLEAN NOT NULL DEFAULT true,
    "influencer_id" UUID,
    "version" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "margin_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "leaderboards" (
    "id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "score" DECIMAL(10,2) NOT NULL,
    "period" "Period" NOT NULL,
    "rank" INTEGER,

    CONSTRAINT "leaderboards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "referrals" (
    "id" UUID NOT NULL,
    "referrer_id" UUID NOT NULL,
    "referred_id" UUID NOT NULL,
    "bonus_awarded" DECIMAL(10,2) NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "referrals_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_campaignsTopackages" (
    "A" UUID NOT NULL,
    "B" UUID NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "users_referral_code_key" ON "users"("referral_code");

-- CreateIndex
CREATE INDEX "users_role_idx" ON "users"("role");

-- CreateIndex
CREATE INDEX "users_referral_code_idx" ON "users"("referral_code");

-- CreateIndex
CREATE INDEX "influencers_user_id_idx" ON "influencers"("user_id");

-- CreateIndex
CREATE INDEX "packages_influencer_id_idx" ON "packages"("influencer_id");

-- CreateIndex
CREATE UNIQUE INDEX "transactions_transaction_ref_key" ON "transactions"("transaction_ref");

-- CreateIndex
CREATE INDEX "transactions_user_id_timestamp_idx" ON "transactions"("user_id", "timestamp");

-- CreateIndex
CREATE INDEX "transactions_status_idx" ON "transactions"("status");

-- CreateIndex
CREATE UNIQUE INDEX "codes_code_value_key" ON "codes"("code_value");

-- CreateIndex
CREATE UNIQUE INDEX "codes_spin_id_key" ON "codes"("spin_id");

-- CreateIndex
CREATE INDEX "codes_transaction_id_idx" ON "codes"("transaction_id");

-- CreateIndex
CREATE INDEX "codes_is_used_idx" ON "codes"("is_used");

-- CreateIndex
CREATE UNIQUE INDEX "spins_code_id_key" ON "spins"("code_id");

-- CreateIndex
CREATE INDEX "points_histories_user_id_timestamp_idx" ON "points_histories"("user_id", "timestamp");

-- CreateIndex
CREATE INDEX "points_histories_reason_idx" ON "points_histories"("reason");

-- CreateIndex
CREATE INDEX "products_points_required_idx" ON "products"("points_required");

-- CreateIndex
CREATE INDEX "products_influencer_id_idx" ON "products"("influencer_id");

-- CreateIndex
CREATE INDEX "redeems_user_id_timestamp_idx" ON "redeems"("user_id", "timestamp");

-- CreateIndex
CREATE INDEX "redeems_status_idx" ON "redeems"("status");

-- CreateIndex
CREATE UNIQUE INDEX "coupons_code_key" ON "coupons"("code");

-- CreateIndex
CREATE INDEX "coupons_expire_date_idx" ON "coupons"("expire_date");

-- CreateIndex
CREATE INDEX "coupons_user_id_idx" ON "coupons"("user_id");

-- CreateIndex
CREATE INDEX "horario_slots_start_time_end_time_idx" ON "horario_slots"("start_time", "end_time");

-- CreateIndex
CREATE INDEX "horario_slots_is_active_idx" ON "horario_slots"("is_active");

-- CreateIndex
CREATE INDEX "campaigns_influencer_id_start_date_idx" ON "campaigns"("influencer_id", "start_date");

-- CreateIndex
CREATE UNIQUE INDEX "streaks_user_id_key" ON "streaks"("user_id");

-- CreateIndex
CREATE INDEX "streaks_user_id_last_activity_date_idx" ON "streaks"("user_id", "last_activity_date");

-- CreateIndex
CREATE INDEX "badges_user_id_badge_type_idx" ON "badges"("user_id", "badge_type");

-- CreateIndex
CREATE INDEX "audit_logs_action_type_timestamp_idx" ON "audit_logs"("action_type", "timestamp");

-- CreateIndex
CREATE INDEX "margin_configs_influencer_id_version_idx" ON "margin_configs"("influencer_id", "version");

-- CreateIndex
CREATE UNIQUE INDEX "margin_configs_influencer_id_version_key" ON "margin_configs"("influencer_id", "version");

-- CreateIndex
CREATE INDEX "leaderboards_period_idx" ON "leaderboards"("period");

-- CreateIndex
CREATE INDEX "leaderboards_user_id_idx" ON "leaderboards"("user_id");

-- CreateIndex
CREATE INDEX "referrals_referrer_id_idx" ON "referrals"("referrer_id");

-- CreateIndex
CREATE UNIQUE INDEX "referrals_referrer_id_referred_id_key" ON "referrals"("referrer_id", "referred_id");

-- CreateIndex
CREATE UNIQUE INDEX "_campaignsTopackages_AB_unique" ON "_campaignsTopackages"("A", "B");

-- CreateIndex
CREATE INDEX "_campaignsTopackages_B_index" ON "_campaignsTopackages"("B");

-- AddForeignKey
ALTER TABLE "influencers" ADD CONSTRAINT "influencers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "packages" ADD CONSTRAINT "packages_influencer_id_fkey" FOREIGN KEY ("influencer_id") REFERENCES "influencers"("user_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transactions" ADD CONSTRAINT "transactions_coupon_id_fkey" FOREIGN KEY ("coupon_id") REFERENCES "coupons"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "codes" ADD CONSTRAINT "codes_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "transactions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spins" ADD CONSTRAINT "spins_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spins" ADD CONSTRAINT "spins_code_id_fkey" FOREIGN KEY ("code_id") REFERENCES "codes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "spins" ADD CONSTRAINT "spins_horario_slot_id_fkey" FOREIGN KEY ("horario_slot_id") REFERENCES "horario_slots"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "points_histories" ADD CONSTRAINT "points_histories_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "points_histories" ADD CONSTRAINT "points_histories_reference_id_fkey" FOREIGN KEY ("reference_id") REFERENCES "spins"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_influencer_id_fkey" FOREIGN KEY ("influencer_id") REFERENCES "influencers"("user_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "redeems" ADD CONSTRAINT "redeems_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "redeems" ADD CONSTRAINT "redeems_product_id_fkey" FOREIGN KEY ("product_id") REFERENCES "products"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "coupons" ADD CONSTRAINT "coupons_package_id_fkey" FOREIGN KEY ("package_id") REFERENCES "packages"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "horario_slots" ADD CONSTRAINT "horario_slots_influencer_id_fkey" FOREIGN KEY ("influencer_id") REFERENCES "influencers"("user_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_influencer_id_fkey" FOREIGN KEY ("influencer_id") REFERENCES "influencers"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "streaks" ADD CONSTRAINT "streaks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "badges" ADD CONSTRAINT "badges_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "margin_configs" ADD CONSTRAINT "margin_configs_influencer_id_fkey" FOREIGN KEY ("influencer_id") REFERENCES "influencers"("user_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "leaderboards" ADD CONSTRAINT "leaderboards_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referrer_id_fkey" FOREIGN KEY ("referrer_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "referrals" ADD CONSTRAINT "referrals_referred_id_fkey" FOREIGN KEY ("referred_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_campaignsTopackages" ADD CONSTRAINT "_campaignsTopackages_A_fkey" FOREIGN KEY ("A") REFERENCES "campaigns"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_campaignsTopackages" ADD CONSTRAINT "_campaignsTopackages_B_fkey" FOREIGN KEY ("B") REFERENCES "packages"("id") ON DELETE CASCADE ON UPDATE CASCADE;
