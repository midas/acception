defmodule Acception.WriterPg.Repo do
  use Ecto.Repo,
    otp_app: :writer_pg,
    adapter: Ecto.Adapters.Postgres
end
