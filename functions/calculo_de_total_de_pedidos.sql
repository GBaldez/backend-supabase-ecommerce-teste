CREATE OR REPLACE FUNCTION public.total_pedido(p_pedido_id bigint)
RETURNS numeric
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(p.valor, 0)::numeric
  FROM public.pedidos ped
  LEFT JOIN public.produtos p ON p.id = ped.id_produto
  WHERE ped.id = p_pedido_id;
$$;

CREATE OR REPLACE FUNCTION public.total_pedidos_cliente(p_cliente_id bigint)
RETURNS numeric
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(SUM(p.valor), 0)::numeric
  FROM public.pedidos ped
  LEFT JOIN public.produtos p ON p.id = ped.id_produto
  WHERE ped.id_cliente = p_cliente_id;
$$;

CREATE OR REPLACE FUNCTION public.total_pedidos_all()
RETURNS numeric
LANGUAGE sql STABLE
AS $$
  SELECT COALESCE(SUM(p.valor), 0)::numeric
  FROM public.pedidos ped
  LEFT JOIN public.produtos p ON p.id = ped.id_produto;
$$;