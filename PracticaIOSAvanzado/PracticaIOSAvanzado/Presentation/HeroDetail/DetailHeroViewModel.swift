

class DetailHeroViewModel {
    
    private var useCase: DetailHeroUseCaseProtocol
    
    init(useCase: DetailHeroUseCaseProtocol = DetailHeroUseCase()) {
        self.useCase = useCase
    }
}
