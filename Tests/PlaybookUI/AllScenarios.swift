import PlaybookUI

struct AllScenarios: ScenarioProvider {
    static func addScenarios(into playbook: Playbook) {
        playbook
            .add(GalleryScenarios.self)
            .add(CatalogScenarios.self)
    }
}
