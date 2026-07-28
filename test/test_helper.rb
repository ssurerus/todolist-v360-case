ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Execucao serial para saida deterministica no case (sem multiplos DBs de teste).
    parallelize(workers: 1)

    # Nao usamos fixtures: cada teste cria seus proprios registros no setup,
    # deixando explicito o cenario e evitando acoplamento a dados globais.
  end
end
