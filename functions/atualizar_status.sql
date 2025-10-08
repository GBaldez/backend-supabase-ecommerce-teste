create or replace function public.atualizar_status_pedido(pedido_id bigint, novo_status text)
returns void
language plpgsql
security invoker
set search_path = ''
as $$
begin
  -- Validação do status
  if upper(novo_status) not in ('PENDENTE', 'APROVADO', 'CANCELADO') then
    raise exception 'Status inválido: %. Valores aceitos: PENDENTE, APROVADO, CANCELADO.', novo_status;
  end if;

  -- Atualiza o status do pedido
  update public.pedidos
  set status = upper(novo_status)
  where id = atualizar_status_pedido.pedido_id;

  -- Verifica se algum pedido foi atualizado
  if not found then
    raise exception 'Pedido com ID % não encontrado.', pedido_id;
  end if;
end;
$$;
