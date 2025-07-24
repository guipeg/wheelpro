import { Module } from '@nestjs/common';
import { PrismaModule } from './prisma/prisma.module';
import { TestModule } from './modules/test/test.module';

@Module({
  imports: [
    PrismaModule,
    TestModule,
  ],
})
export class AppModule {}
