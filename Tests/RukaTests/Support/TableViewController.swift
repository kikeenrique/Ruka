#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif


class TableViewController: UIViewController {
    static let labelText = "Label text"
    static let labelTextChanged = "Changed label text"

    private let label = UILabel()
    private let tableView = UITableView()

    private let strings = [
        "One",
        "Two",
        "Three",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        installLabel()
        installTableView()
    }

    private func installLabel() {
        label.text = TableViewController.labelText
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
    }

    private func installTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),

            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! TableViewCell
        cell.label.text = strings[indexPath.row]
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        label.text = TableViewController.labelTextChanged
    }
}

private class TableViewCell: UITableViewCell {
    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
