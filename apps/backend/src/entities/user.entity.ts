import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password_hash: string;

  @Column()
  name: string;

  @Column({ type: 'varchar' })
  role: 'pilot' | 'shop_manager' | 'technician' | 'admin';

  @CreateDateColumn()
  created_at: Date;
}
