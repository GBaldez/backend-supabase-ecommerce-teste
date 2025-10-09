create or replace function public.total_do_pedido()
returns trigger
language plpgsql
security invoker
set search_path = ''
as $$
declare
  unit_price numeric(10, 2);
begin
  -- 1. Busca o preço unitário do produto na tabela public.produtos
  select preco
  into unit_price
  from public.produtos
  where id = new.id_produto;

  -- 2. Verifica se o produto foi encontrado
  if not found then
    raise exception 'Product with ID % not found.', new.id_produto;
  end if;

  -- 3. Calcula o total do pedido: preco * quantidade
  new.total := unit_price * new.quantidade;
  
  return new;
end;
$$;