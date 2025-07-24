// apps/frontend/app/auth/login/page.tsx
// Propósito: Gerencia o fluxo de login do usuário, integrando com authStore para estado de autenticação global.
// Jornada do Usuário: Entrada via email/senha; validação client-side; mutation GraphQL para backend; redirect para /dashboard on success.
// Decisões Técnicas:
// - Mobile-First: Layout flex col com max-w-md para telas pequenas; inputs large para touch; padding p-4.
// - SSR/PWA: Client-side auth (useEffect para redirect); compatível com service-worker offline (mas auth requer online).
// - Acessibilidade: ARIA labels/invalid/describedby; role="alert" para errors; autofocus no primeiro input; keyboard nav implícito.
// - Performance: Lazy imports se necessário (não aqui); minimal DOM; Framer para fade-in suave sem overhead.
// - Integração: useGraphQL hook para LOGIN_MUTATION (de services/api/mutations.ts); zustand para store token/user.
// - Validação: zod + react-hook-form; i18n para mensagens.
// - Segurança: Password type; no local storage sensível (store gerencia).
// - Reuso: Button de components/common; hooks/stores de paths aliases.
// - Gamificação: Pós-login, futuro hook para streak init (não implementado aqui, mas preparado via store).
// - i18n: Todos textos via t() para multi-locale.

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { motion } from 'framer-motion';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { useI18n } from '@hooks/useI18n';
import { useGraphQL } from '@hooks/useGraphQL';
import { useAuthStore } from '@stores/authStore';
import Button from '@components/common/Button';
import { LoginInput, User } from '@core/types'; // Interfaces de core: LoginInput { email: string; password: string; }, User { id: string; ... }

const loginSchema = z.object({
  email: z.string().email({ message: 'auth.login.errors.invalidEmail' }), // Mensagem como key i18n
  password: z.string().min(6, { message: 'auth.login.errors.passwordMin' }),
});

type LoginFormData = z.infer<typeof loginSchema>;

const fadeInVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5, ease: 'easeOut' } },
};

const LoginPage = () => {
  const { t } = useI18n();
  const router = useRouter();
  const { loginMutation } = useGraphQL(); // Retorna { mutate, loading, error } para LOGIN_MUTATION
  const { user, login, loading: authLoading, error: authError, clearError } = useAuthStore();

  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  });

  useEffect(() => {
    clearError(); // Limpa erros prévios ao mount
    if (user) {
      router.push('/dashboard');
    }
  }, [user, router, clearError]);

  const onSubmit = async (data: LoginFormData) => {
    try {
      const response = await loginMutation({ variables: { input: data } });
      const { access_token, user: responseUser } = response.data.login as { access_token: string; user: User };
      login({ token: access_token, user: responseUser }); // Atualiza store
      router.push('/dashboard');
    } catch (err) {
      // Erro handled in store via mutation error
    }
  };

  return (
    <motion.div
      className="flex min-h-screen flex-col items-center justify-center bg-background p-4"
      initial="hidden"
      animate="visible"
      variants={fadeInVariants}
    >
      <div className="w-full max-w-md space-y-8">
        <h2 className="text-center text-2xl font-bold text-foreground">{t('auth.login.title')}</h2>
        <form onSubmit={handleSubmit(onSubmit)} className="space-y-6">
          <div>
            <label htmlFor="email" className="block text-sm font-medium text-foreground">
              {t('auth.login.email')}
            </label>
            <input
              id="email"
              type="email"
              {...register('email')}
              className="mt-1 block w-full rounded-md border border-input bg-background px-3 py-2 text-foreground shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              aria-invalid={!!errors.email}
              aria-describedby={errors.email ? 'email-error' : undefined}
              autoFocus
            />
            {errors.email && (
              <p id="email-error" role="alert" className="mt-1 text-sm text-destructive">
                {t(errors.email.message!)}
              </p>
            )}
          </div>
          <div>
            <label htmlFor="password" className="block text-sm font-medium text-foreground">
              {t('auth.login.password')}
            </label>
            <input
              id="password"
              type="password"
              {...register('password')}
              className="mt-1 block w-full rounded-md border border-input bg-background px-3 py-2 text-foreground shadow-sm focus:border-primary focus:ring-primary sm:text-sm"
              aria-invalid={!!errors.password}
              aria-describedby={errors.password ? 'password-error' : undefined}
            />
            {errors.password && (
              <p id="password-error" role="alert" className="mt-1 text-sm text-destructive">
                {t(errors.password.message!)}
              </p>
            )}
          </div>
          {authError && (
            <p role="alert" className="text-sm text-destructive">
              {t(authError)} {/* authError como key i18n ou mensagem */}
            </p>
          )}
          <Button
            type="submit"
            disabled={isSubmitting || authLoading}
            className="w-full"
          >
            {authLoading ? t('auth.login.loading') : t('auth.login.submit')}
          </Button>
        </form>
        <p className="text-center text-sm text-muted-foreground">
          {t('auth.login.noAccount')} <a href="/auth/register" className="text-primary hover:underline">{t('auth.login.registerLink')}</a>
        </p>
      </div>
    </motion.div>
  );
};

export default LoginPage;