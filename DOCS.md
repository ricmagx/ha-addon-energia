# Monitorizacao Electricidade — Add-on HA

Dashboard de monitorizacao de electricidade com comparacao de tarifarios.

## Instalacao

1. No HA, ir a **Settings > Add-ons > Add-on Store**
2. Menu (3 pontos) > **Repositories** > adicionar o URL deste repositorio
3. Instalar "Monitorizacao Electricidade"
4. Iniciar o add-on
5. O painel "Energia" aparece no menu lateral

## Dados

- A BD SQLite fica em `/data/energia.db` (persistente entre restarts)
- Uploads de XLSX e PDF sao feitos pela UI web
- Tarifarios configurados em `config/tarifarios.json` dentro do add-on

## Notas

- Usa Ingress do HA (sem porta extra exposta)
- Autenticacao gerida pelo HA automaticamente
