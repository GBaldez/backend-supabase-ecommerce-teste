create table public.clientes (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE, 
  nome text not null,
  email text not null,
  endereco text not null,
  created_at timestamp with time zone not null default now(),
  telefone text not null,
  constraint clientes_pkey primary key (id),
  constraint clientes_email_key unique (email),
  constraint clientes_telefone_key unique (telefone)
) TABLESPACE pg_default;


ALTER TABLE public.clientes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Select: apenas o próprio cliente pode ver seus dados"
ON public.clientes
FOR SELECT
TO authenticated
USING (auth_user_id = (SELECT auth.uid()));

CREATE POLICY "Insert: apenas usuários autenticados podem criar seu próprio registro"
ON public.clientes
FOR INSERT
TO authenticated
WITH CHECK (auth_user_id = (SELECT auth.uid()));

CREATE POLICY "Update: apenas usuários autenticados podem atualizar seu próprio registro"
ON public.clientes
FOR UPDATE
TO authenticated
USING (auth_user_id = (SELECT auth.uid()))
WITH CHECK (auth_user_id = (SELECT auth.uid()));

CREATE POLICY "Delete: apenas usuários autenticados com papel de admin podem deletar registros"
ON public.clientes
FOR DELETE
TO authenticated
USING ((auth.jwt() ->> 'role') = 'admin');
