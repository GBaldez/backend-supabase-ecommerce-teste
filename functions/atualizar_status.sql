create or replace function public.atualizar_status_pedido(
  p_pedido_id bigint,
  p_novo_status public.status_pedido
)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  update public.pedidos
  set status = p_novo_status
  where id = p_pedido_id;
end;
$$;