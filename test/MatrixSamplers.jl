using RandomMatrixDistributions
using Distributions
using Test

@testset "MatrixSamplers" begin

    n = 1000
    p = 400
    γ = p/n

    # test white Wishart
    for beta in [1, 4, 8]
        #println("Testing white Wishart with β = ", beta)
        
        λs = randeigvals(SpikedWishart(beta, n, p))

        @test length(λs) == p
        @test eltype(λs) <: Real

        @test minimum(λs) > 0

        #println("Testing Jacobi with β = ", beta)
        λs = randeigvals(Jacobi(beta, n, n, p))

        @test length(λs) == p
        @test eltype(λs) <: Real

        @test minimum(λs) > 0
    end

    #println("Testing Spiked Wishart with β = 1")
    s = 8
    W = SpikedWishart(1, n, p, [0.1, 2, 4, s])
    λs = randeigvals(W)/n
    
    @test length(λs) == p
    @test eltype(λs) <: Real

    # Check if the maximum spike is reasonable
    # This tests can fail in principle, but only with negligible probability
    #μ = (1 + s) * (1 + γ/s)
    #σ = (1 + s) * sqrt(γ * 2 * (1 - γ/s^2))

    spikedist = covspikedist(W)
    μ = mean(spikedist)[end]
    σ = sqrt(var(spikedist)[end])

    @test abs(maximum(λs) - μ)/σ < 4

    @test all(randeigstat(W, eigmax, 10) .> 0)

end
