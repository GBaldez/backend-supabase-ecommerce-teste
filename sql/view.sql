create view public.pedidos_entregues as
select
  id,
  id_produto,
  id_cliente,
  status,
  quantidade,
  total,
  forma_pagamento,
  created_at,
  updated_at
from
  pedidos
where
  status = 'entregue'::status_pedido;