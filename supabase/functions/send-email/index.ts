// supabase/functions/enviar_email_confirmacao/index.ts
import { createClient } from "@supabase/supabase-js"
import { serve } from "https://deno.land/std@0.203.0/http/server.ts"

const supabase = createClient(
  process.env.SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
)

console.info("Função enviar_email_confirmacao iniciada")
serve(async (req) => {
  try {
    const { pedido_id } = await req.json()
    const { pedido_id } = await req.json()

    // Busca dados do pedido
    const { data: pedido, error } = await supabase
      .from("pedidos")
      .select("id, total, cliente:clientes(email, nome)")
      .eq("id", pedido_id)
      .single()

    if (error || !pedido) throw new Error("Pedido não encontrado")

    // Simulação de envio de e-mail (você pode integrar com Resend ou SendGrid depois)
    console.log(`Enviando e-mail para ${pedido.cliente.email}`)
    console.log(`Olá ${pedido.cliente.nome}, seu pedido #${pedido.id} foi confirmado! Total: R$${pedido.total}`)

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { "Content-Type": "application/json" } }
    )
  } catch (err) {
    console.error(err)
    return new Response(
      JSON.stringify({ error: "Erro ao enviar e-mail" }),
      { status: 500 }
    )
  }
})
