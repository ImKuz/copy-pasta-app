import Swinject
import RootFeature
import CatalogFeature
import AddItemFeature
import IPAddressProvider
import CatalogServer

struct AppAssemblerFactory {

    let container: Container

    init(rootContainer: Container) {
        self.container = rootContainer
    }

    func assembler() -> Assembler {
        let assmbler = Assembler(container: container)
        applyAssemblies(to: assmbler)
        return assmbler
    }

    private func applyAssemblies(to assembler: Assembler) {
        assembler.apply(assemblies: [
            // MARK: - Services

            ServicesAssembly(),
            IPAddressProviderAssembly(),
            CatalogServerAssembly(),

            // MARK: - Features

            RootFeatureAssembly(container: container),
            CatalogFeatureAssembly(container: container),
            AddItemFeatureAssembly(container: container),
        ])
    }
}
