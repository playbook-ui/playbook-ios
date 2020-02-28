import SwiftUI

internal struct TableView<SectionData: Hashable, RowData: Hashable, Row: View>: UIViewRepresentable {
    var animated: Bool
    var snapshot: NSDiffableDataSourceSnapshot<SectionData, RowData>
    var configureUIView: ((UITableView) -> Void)?
    var row: (RowData) -> Row
    var onSelect: ((RowData) -> Void)?

    init(
        animated: Bool = true,
        snapshot: NSDiffableDataSourceSnapshot<SectionData, RowData>,
        configureUIView: ((UITableView) -> Void)?,
        row: @escaping (RowData) -> Row,
        onSelect: ((RowData) -> Void)? = nil
    ) {
        self.animated = animated
        self.snapshot = snapshot
        self.configureUIView = configureUIView
        self.row = row
        self.onSelect = onSelect
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(base: self)
    }

    func makeUIView(context: Context) -> UIViewType {
        let tableView = UIViewType()
        let dataSource = UITableViewDiffableDataSource<SectionData, RowData>(tableView: tableView) { tableView, indexPath, _ in
            context.coordinator.dequeueCell(for: tableView, indexPath: indexPath)
        }

        tableView.backgroundColor = .clear
        dataSource.defaultRowAnimation = .fade
        context.coordinator.dataSource = dataSource
        configureUIView?(tableView)

        return tableView
    }

    func updateUIView(_ tableView: UIViewType, context: Context) {
        context.coordinator.base = self
        tableView.dataSource = context.coordinator.dataSource
        tableView.delegate = context.coordinator
        tableView.allowsSelection = onSelect != nil
        tableView.readyForUpdate = nil

        if tableView.window != nil {
            let dataSource = context.coordinator.dataSource
            let isEmptyBefore = dataSource?.snapshot().sectionIdentifiers.isEmpty ?? false
            dataSource?.apply(snapshot, animatingDifferences: animated && !isEmptyBefore)
        }
        else {
            tableView.readyForUpdate = { [weak tableView] in
                guard let tableView = tableView else { return }
                self.updateUIView(tableView, context: context)
            }
        }
    }
}

internal extension TableView {
    final class UIViewType: UITableView {
        var readyForUpdate: (() -> Void)?

        override func layoutSubviews() {
            if window != nil {
                super.layoutSubviews()
                readyForUpdate?()
                readyForUpdate = nil
            }
        }
    }

    final class Coordinator: NSObject, UITableViewDelegate {
        var base: TableView
        var dataSource: UITableViewDiffableDataSource<SectionData, RowData>?

        init(base: TableView) {
            self.base = base
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            guard let onSelect = base.onSelect else { return }

            let sectionData = base.snapshot.sectionIdentifiers[indexPath.section]
            let rowData = base.snapshot.itemIdentifiers(inSection: sectionData)[indexPath.row]

            onSelect(rowData)
            tableView.deselectRow(at: indexPath, animated: false)
        }

        func dequeueCell(for tableView: UITableView, indexPath: IndexPath) -> Cell<Row> {
            let sectionData = base.snapshot.sectionIdentifiers[indexPath.section]
            let rowData = base.snapshot.itemIdentifiers(inSection: sectionData)[indexPath.row]
            let reuseIdentifier = rowData.hashValue.description

            guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? Cell<Row> else {
                tableView.register(Cell<Row>.self, forCellReuseIdentifier: reuseIdentifier)
                return dequeueCell(for: tableView, indexPath: indexPath)
            }

            cell.hostingController.rootView = base.row(rowData)
            return cell
        }
    }

    final class Cell<Content: View>: UITableViewCell {
        let hostingController = UIHostingController<Content?>(rootView: nil)

        override init(style: CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            layout()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }

        private func layout() {
            hostingController.view.backgroundColor = .clear
            hostingController.view.translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .clear
            contentView.backgroundColor = .clear
            contentView.addSubview(hostingController.view)

            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
                contentView.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor),
            ])
        }
    }
}
