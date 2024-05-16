import PlaybookUI

@available(iOS 15.0, *)
struct AllScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook
            .add(GalleryScenarios.self)
            .add(CatalogScenarios.self)
            .add(ExtraScenarios.self)
    }
}
