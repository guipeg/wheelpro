import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  /**
   * Deleta todos os dados de todas as tabelas (exceto relacionamentos protegidos)
   * Use com cautela, geralmente apenas em ambiente de desenvolvimento.
   */
  async clearDatabase() {
    const modelKeys = Object.keys(this).filter((key) => {
      const prop = (this as any)[key];
      return (
        typeof prop === 'object' &&
        prop !== null &&
        typeof prop.deleteMany === 'function'
      );
    });

    for (const model of modelKeys) {
      await (this as any)[model].deleteMany({});
    }
  }
}
