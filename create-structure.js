const fs = require('fs');
const path = require('path');

// Função para criar diretório recursivamente
function createDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`📁 Criado: ${dirPath}`);
  }
}

// Função para criar arquivo vazio
function createFile(filePath) {
  const dir = path.dirname(filePath);
  createDir(dir);
  
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, '');
    console.log(`📄 Criado: ${filePath}`);
  }
}

// Estrutura do projeto
const projectStructure = {
  'spin-system-monorepo': {
    // Arquivos raiz
    files: [
      '.env',
      '.env.example',
      '.eslintrc.js',
      '.gitignore',
      '.prettierrc',
      'docker-compose.yml',
      'package.json',
      'pnpm-workspace.yaml',
      'tsconfig.base.json',
      'turbo.json'
    ],
    
    // Diretórios
    dirs: {
      '.github/workflows': {
        files: [
          'ci.yml',
          'cd-frontend.yml',
          'cd-backend.yml',
          'cd-admin.yml'
        ]
      },
      
      'packages/core': {
        files: [
          'package.json',
          'tsconfig.json',
          'README.md'
        ],
        dirs: {
          'src/constants': {
            files: [
              'business.ts',
              'roles.ts',
              'gamification.ts'
            ]
          },
          'src/libs/probability': {
            files: [
              'cdf.ts',
              'seeder.ts',
              'rtpCalculator.ts'
            ]
          },
          'src/libs/web3': {
            files: [
              'contract.ts',
              'wallet.ts'
            ]
          },
          'src/libs': {
            files: [
              'marginSimulator.ts',
              'iaHelpers.ts'
            ]
          },
          'src/types': {
            files: [
              'index.ts',
              'user.ts',
              'package.ts',
              'spin.ts',
              'coupon.ts',
              'horario_slot.ts',
              'transaction.ts',
              'product.ts',
              'redeem.ts',
              'streak.ts',
              'badge.ts',
              'leaderboard.ts',
              'referral.ts',
              'audit_log.ts',
              'margin_config.ts',
              'campaign.ts'
            ]
          },
          'src/utils': {
            files: [
              'validators.ts',
              'sanitizers.ts',
              'formatters.ts',
              'logger.ts',
              'helpers.ts'
            ]
          },
          'src/configs': {
            files: [
              'roleta.ts',
              'i18n.ts'
            ]
          },
          'tests/libs': {},
          'tests/types': {},
          'tests/utils': {},
          'tests/mocks': {}
        }
      },
      
      'apps/frontend': {
        files: [
          'package.json',
          'next.config.js',
          'tsconfig.json',
          'tailwind.config.js',
          'Dockerfile',
          'README.md'
        ],
        dirs: {
          'app': {
            files: [
              'layout.tsx',
              'page.tsx'
            ]
          },
          'app/dashboard': {
            files: [
              'page.tsx',
              'layout.tsx'
            ]
          },
          'app/dashboard/components': {},
          'app/packages': {
            files: ['page.tsx']
          },
          'app/packages/[id]': {
            files: ['page.tsx']
          },
          'app/packages/checkout': {
            files: ['page.tsx']
          },
          'app/spin': {
            files: ['page.tsx']
          },
          'app/spin/history': {
            files: ['page.tsx']
          },
          'app/store': {
            files: ['page.tsx']
          },
          'app/store/[id]': {
            files: ['page.tsx']
          },
          'app/profile': {
            files: ['page.tsx']
          },
          'app/auth/login': {
            files: ['page.tsx']
          },
          'app/auth/register': {
            files: ['page.tsx']
          },
          'components/common': {},
          'components/layout': {},
          'components/forms': {},
          'components/spin': {},
          'components/store': {},
          'components/dashboard': {},
          'components/ui': {},
          'hooks': {
            files: [
              'useSpinAnimation.ts',
              'useOfflineSync.ts',
              'useAuth.ts',
              'useGraphQL.ts',
              'useI18n.ts'
            ]
          },
          'stores': {
            files: [
              'authStore.ts',
              'pointsStore.ts',
              'spinStore.ts',
              'packageStore.ts',
              'globalStore.ts'
            ]
          },
          'services/api': {
            files: [
              'client.ts',
              'queries.ts',
              'mutations.ts'
            ]
          },
          'services': {
            files: [
              'payment.ts',
              'notification.ts',
              'web3.ts'
            ]
          },
          'themes/default': {},
          'themes/custom': {},
          'public': {
            files: [
              'manifest.json',
              'favicon.ico',
              'service-worker.js'
            ]
          },
          'public/images': {},
          'i18n/locales': {},
          'i18n': {
            files: ['config.ts']
          },
          'tests/components': {},
          'tests/hooks': {},
          'tests/pages': {},
          'tests/stores': {},
          'tests/mocks': {},
          'tests/e2e': {}
        }
      },
      
      'apps/backend': {
        files: [
          'package.json',
          'nest-cli.json',
          'tsconfig.json',
          'serverless.yml',
          'Dockerfile',
          'README.md'
        ],
        dirs: {
          'src': {
            files: [
              'main.ts',
              'app.module.ts'
            ]
          },
          'src/common/guards': {},
          'src/common/middlewares': {},
          'src/common/utils': {},
          'src/common/validations': {},
          'src/common/interceptors': {},
          'src/common/filters': {},
          'src/common/decorators': {},
          'src/prisma': {
            files: [
              'prisma.service.ts',
              'schema.prisma'
            ]
          },
          'src/prisma/migrations': {},
          'src/cron/jobs': {},
          'src/event-sourcing': {},
          'src/modules/auth': {
            files: ['auth.module.ts']
          },
          'src/modules/auth/controllers': {},
          'src/modules/auth/resolvers': {},
          'src/modules/auth/services': {},
          'src/modules/auth/use-cases': {},
          'src/modules/auth/entities': {},
          'src/modules/auth/repositories': {},
          'src/modules/auth/interfaces': {},
          'src/modules/auth/dtos': {},
          'src/modules/auth/tests': {},
          'src/modules/gamification': {
            files: ['gamification.module.ts']
          },
          'src/modules/gamification/controllers': {},
          'src/modules/gamification/resolvers': {},
          'src/modules/gamification/services': {},
          'src/modules/gamification/use-cases': {},
          'src/modules/gamification/entities': {},
          'src/modules/gamification/repositories': {},
          'src/modules/gamification/interfaces': {},
          'src/modules/gamification/dtos': {},
          'src/modules/gamification/tests': {},
          'src/modules/payment': {
            files: ['payment.module.ts']
          },
          'src/modules/payment/controllers': {},
          'src/modules/payment/resolvers': {},
          'src/modules/payment/services': {},
          'src/modules/payment/use-cases': {},
          'src/modules/payment/entities': {},
          'src/modules/payment/repositories': {},
          'src/modules/payment/interfaces': {},
          'src/modules/payment/dtos': {},
          'src/modules/payment/tests': {},
          'src/modules/spin': {
            files: ['spin.module.ts']
          },
          'src/modules/spin/controllers': {},
          'src/modules/spin/resolvers': {},
          'src/modules/spin/services': {},
          'src/modules/spin/use-cases': {},
          'src/modules/spin/entities': {},
          'src/modules/spin/repositories': {},
          'src/modules/spin/interfaces': {},
          'src/modules/spin/dtos': {},
          'src/modules/spin/tests': {},
          'src/modules/packages': {
            files: ['packages.module.ts']
          },
          'src/modules/packages/controllers': {},
          'src/modules/packages/resolvers': {},
          'src/modules/packages/services': {},
          'src/modules/packages/use-cases': {},
          'src/modules/packages/entities': {},
          'src/modules/packages/repositories': {},
          'src/modules/packages/interfaces': {},
          'src/modules/packages/dtos': {},
          'src/modules/packages/tests': {},
          'src/modules/admin': {
            files: ['admin.module.ts']
          },
          'src/modules/admin/controllers': {},
          'src/modules/admin/resolvers': {},
          'src/modules/admin/services': {},
          'src/modules/admin/use-cases': {},
          'src/modules/admin/entities': {},
          'src/modules/admin/repositories': {},
          'src/modules/admin/interfaces': {},
          'src/modules/admin/dtos': {},
          'src/modules/admin/tests': {},
          'src/modules/notifications': {
            files: ['notifications.module.ts']
          },
          'src/modules/notifications/controllers': {},
          'src/modules/notifications/resolvers': {},
          'src/modules/notifications/services': {},
          'src/modules/notifications/use-cases': {},
          'src/modules/notifications/entities': {},
          'src/modules/notifications/repositories': {},
          'src/modules/notifications/interfaces': {},
          'src/modules/notifications/dtos': {},
          'src/modules/notifications/tests': {},
          'tests/e2e': {},
          'tests/mocks': {},
          'tests/seeds': {}
        }
      },
      
      'apps/admin': {
        files: [
          'package.json',
          'vite.config.js',
          'tsconfig.json',
          'tailwind.config.js',
          'Dockerfile',
          'README.md'
        ],
        dirs: {
          'src': {
            files: [
              'main.ts',
              'App.vue'
            ]
          },
          'src/assets': {},
          'src/components/common': {},
          'src/components/forms': {},
          'src/components/builders': {},
          'src/components/charts': {},
          'src/components/metrics': {},
          'src/composables': {
            files: [
              'useGraphQLQuery.ts',
              'useFormValidation.ts',
              'useI18n.ts'
            ]
          },
          'src/stores': {
            files: [
              'adminStore.ts',
              'globalStore.ts'
            ]
          },
          'src/views': {
            files: [
              'DashboardView.vue',
              'PackagesView.vue',
              'CampaignsView.vue',
              'ReportsView.vue'
            ]
          },
          'src/router': {
            files: ['index.ts']
          },
          'src/services': {
            files: ['apiClient.ts']
          },
          'src/themes': {},
          'src/utils': {},
          'public': {},
          'i18n/locales': {},
          'i18n': {
            files: ['config.ts']
          },
          'tests/components': {},
          'tests/composables': {},
          'tests/views': {},
          'tests/mocks': {},
          'tests/e2e': {}
        }
      }
    }
  }
};

// Função recursiva para processar a estrutura
function processStructure(basePath, structure) {
  for (const [name, content] of Object.entries(structure)) {
    const fullPath = path.join(basePath, name);
    
    if (content.files) {
      // Criar diretório
      createDir(fullPath);
      
      // Criar arquivos no diretório
      if (content.files.length > 0) {
        content.files.forEach(file => {
          createFile(path.join(fullPath, file));
        });
      }
      
      // Processar subdiretórios
      if (content.dirs) {
        processStructure(fullPath, content.dirs);
      }
    } else {
      // É um diretório vazio
      createDir(fullPath);
    }
  }
}

// Executar o script
console.log('🚀 Iniciando criação da estrutura do projeto...\n');

const startTime = Date.now();

try {
  processStructure('.', projectStructure);
  
  const endTime = Date.now();
  const duration = (endTime - startTime) / 1000;
  
  console.log('\n✅ Estrutura do projeto criada com sucesso!');
  console.log(`⏱️  Tempo total: ${duration.toFixed(2)} segundos`);
  console.log('\n📌 Próximos passos:');
  console.log('1. Entre na pasta: cd spin-system-monorepo');
  console.log('2. Instale as dependências: pnpm install');
  console.log('3. Configure o arquivo .env com suas variáveis');
  console.log('4. Comece a desenvolver! 🎉');
  
} catch (error) {
  console.error('\n❌ Erro ao criar estrutura:', error.message);
  process.exit(1);
}