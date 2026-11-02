-- ============================================================
-- Nexora Pro · Cuenta y copia en la nube (Supabase, plan gratis)
-- ============================================================
-- PASOS (una sola vez):
-- 1. Entra a https://supabase.com, crea una cuenta y un proyecto nuevo.
-- 2. En el proyecto abre "SQL Editor", pega TODO este archivo y pulsa Run.
-- 3. Ve a Authentication -> Providers -> Email y deja activado "Email".
--    (Opcional) Desactiva "Confirm email" si quieres que entren sin confirmar el correo.
-- 4. Ve a Authentication -> Emails -> plantilla "Reset Password" y cambia el texto para que
--    muestre el código:   Tu código para Nexora Pro es: {{ .Token }}
-- 5. Ve a Project Settings -> API y copia "Project URL" y "anon public key".
-- 6. En index.html busca  const NX_CLOUD = { url:'', key:'' };  y pega los dos valores.
-- ============================================================

create table if not exists public.nexora_backups (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  data       jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.nexora_backups enable row level security;

drop policy if exists "ver mi copia"      on public.nexora_backups;
drop policy if exists "crear mi copia"    on public.nexora_backups;
drop policy if exists "cambiar mi copia"  on public.nexora_backups;
drop policy if exists "borrar mi copia"   on public.nexora_backups;

create policy "ver mi copia"     on public.nexora_backups for select using (auth.uid() = user_id);
create policy "crear mi copia"   on public.nexora_backups for insert with check (auth.uid() = user_id);
create policy "cambiar mi copia" on public.nexora_backups for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "borrar mi copia"  on public.nexora_backups for delete using (auth.uid() = user_id);
