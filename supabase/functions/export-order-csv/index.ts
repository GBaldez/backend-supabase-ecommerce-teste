import { serve } from "jsr:@supabase/functions-js/edge-runtime@1.0.0";
import { createClient } from "npm:@supabase/supabase-js@2.39.7";

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
);

console.info("Função export-order-csv iniciada");

serve(async (req) => {
  try {
    const { order_id } = await req.json();

    // Busca dados do pedido e cliente
    const { data: pedido, error } = await supabase
      .from("pedidos")
      .select("id, total, quantidade, status, forma_pagamento, created_at, cliente:clientes(email, nome)")
      .eq("id", order_id)
      .single();

    if (error || !pedido) throw new Error("Pedido não encontrado");

    // Monta CSV
    const headers = [
      "id",
      "cliente_nome",
      "cliente_email",
      "total",
      "quantidade",
      "status",
      "forma_pagamento",
      "created_at"
    ];
    const row = [
      pedido.id,
      pedido.cliente.nome,
      pedido.cliente.email,
      pedido.total,
      pedido.quantidade,
      pedido.status,
      pedido.forma_pagamento,
      pedido.created_at
    ];

    const csv = `${headers.join(",")}\n${row.map(String).join(",")}\n`;

    return new Response(csv, {
      headers: {
        "Content-Type": "text/csv",
        "Content-Disposition": `attachment; filename="pedido_${pedido.id}.csv"`
      }
    });
  } catch (err) {
    console.error(err);
    return new Response(
      JSON.stringify({ error: "Erro ao exportar pedido" }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});