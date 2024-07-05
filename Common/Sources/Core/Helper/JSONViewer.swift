import SwiftUI

struct DebugJsonView: View {

    let json: JsonElement

    init(_ json: String) {
        self.json = JsonElement.parse(json)
    }

    var body: some View {
        JsonView(key: nil, element: json, depth: 0)
            .font(Font(UIFont.monospacedSystemFont(ofSize: 13, weight: .medium)))
    }
}

private struct JsonView: View {

    let key: String?
    let element: JsonElement
    let depth: Int

    @ViewBuilder var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if case .string(let string) = element {
                StringJsonView(string: string)
                    .jsonKey(key)
            }
            if case .int(let int) = element {
                Text(int.description)
                    .foregroundColor(.init(UIColor.systemOrange))
                    .jsonKey(key)
            }
            if case .num(let num) = element {
                Text(num.description)
                    .foregroundColor(.init(UIColor.systemOrange))
                    .jsonKey(key)
            }
            if case .flag(let flag) = element {
                Text("\(flag ? "true" : "false")")
                    .foregroundColor(.init(UIColor.systemBlue))
                    .jsonKey(key)
            }
            if case .null = element {
                Text("null")
                    .foregroundColor(.init(UIColor.systemBlue))
                    .jsonKey(key)
            }
            if case .error(let body) = element {
                Text("Error!")
                    .foregroundColor(.init(UIColor.systemRed))
                Text(body)
                    .foregroundColor(.init(UIColor.systemGray))
            }
            if case .nested(let obj) = element {
                ObjectJsonView(key: key, obj: obj, depth: depth + 1, isOpen: depth <= 1)
            }
            if case .list(let list) = element {
                ListJsonView(key: key, list: list, depth: depth + 1, isOpen: depth <= 1)
            }
        }
    }
}

private struct KeyedJsonView<Content: View>: View {
    let key: String
    let content: Content

    init(_ key: String, @ViewBuilder content: () -> Content) {
        self.key = key
        self.content = content()
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text("\"\(key)\"")
            Text(": ")
            content
        }
    }
}

private struct StringJsonView: View {

    let string: String

    var body: some View {
        if string.starts(with: "http"), let url = URL(string: string) {
            HStack(spacing: 4) {
                Text("\(string)")
                    .foregroundColor(.init(UIColor.systemGreen))
                    .underline()
                Text("(URL)")
                    .foregroundColor(.init(UIColor.systemGray))
            }
            .compositingGroup()
            .contextMenu {
                Button(action: { UIApplication.shared.open(url) }) {
                    Label("Open in Safari", systemImage: "safari")
                }
                Button(action: { UIPasteboard.general.url = url }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
        } else {
            Text("\"\(string)\"")
                .foregroundColor(.init(UIColor.systemGreen))
                .contextMenu {
                    Button(action: { UIPasteboard.general.string = string }) {
                        Label("Copy full text", systemImage: "doc.on.doc")
                    }
                }
        }
    }
}

private struct ObjectJsonView: View {

    let key: String?
    let obj: Dictionary<String, JsonElement>
    let depth: Int
    @State var isOpen = false
    @Namespace private var animation

    var body: some View {
        if obj.isEmpty {
            Text("{ empty object }")
                .foregroundColor(.init(UIColor.systemGray))
                .jsonKey(key)
        } else {
            HStack(spacing: 2) {
                Text("{")
                    .foregroundColor(.init(UIColor.systemGray))
                if !isOpen {
                    Text("...")
                        .background(Color(UIColor.systemGray).opacity(0.3))
                    Text("}")
                        .foregroundColor(.init(UIColor.systemGray))
                        .matchedGeometryEffect(id: "Close", in: animation)
                }
            }
            .jsonKey(key)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture { withAnimation { isOpen.toggle() } }
            if isOpen {
                ForEach(Array(obj.keys).sorted(), id: \.self) { key in
                    let content = obj[key]!
                    JsonView(key: key, element: content, depth: depth)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                Text("}")
                    .foregroundColor(.init(UIColor.systemGray))
                    .matchedGeometryEffect(id: "Close", in: animation)
            }
        }
    }
}

private struct ListJsonView: View {

    let key: String?
    let list: Array<JsonElement>
    let depth: Int
    @State var isOpen = false
    @Namespace private var animation

    var body: some View {
        if list.isEmpty {
            Text("[ empty list ]")
                .foregroundColor(.init(UIColor.systemGray))
                .jsonKey(key)
        } else {
            HStack(spacing: 2) {
                Text("[")
                    .foregroundColor(.init(UIColor.systemGray))
                if !isOpen {
                    Text("...")
                        .background(Color(UIColor.systemGray).opacity(0.3))
                    Text("]")
                        .foregroundColor(.init(UIColor.systemGray))
                        .matchedGeometryEffect(id: "Close", in: animation)
                    Text("\(list.count) items")
                        .foregroundColor(.init(UIColor.systemGray))
                        .scaleEffect(0.8)
                }
            }
            .jsonKey(key)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture { withAnimation { isOpen.toggle() } }
            if isOpen {
                ForEach(list.indices, id: \.self) { index in
                    let content = list[index]
                    JsonView(key: nil, element: content, depth: depth)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                }
                Text("]")
                    .foregroundColor(.init(UIColor.systemGray))
                    .matchedGeometryEffect(id: "Close", in: animation)
            }
        }
    }
}

private extension View {

    @ViewBuilder func jsonKey(_ key: String?) -> some View {
        if let key = key {
            HStack(alignment: .top, spacing: 0) {
                Text("\"\(key)\"")
                Text(": ")
                    .foregroundColor(.init(UIColor.systemGray))
                self
            }
        } else {
            self
        }
    }
}

enum JsonElement: Equatable {

    case string(String)
    case int(Int)
    case num(Double)
    case flag(Bool)
    case nested(Dictionary<String, JsonElement>)
    case list(Array<JsonElement>)
    case null
    case error(String)

    static func parse(_ json: String) -> JsonElement {
        if json.isEmpty {
            return .error("{empty}")
        }

        do {
            return map(try JSONSerialization
                .jsonObject(
                    with: json.data(using: .utf8)!,
                    options: [.fragmentsAllowed]
                )
            )
        } catch {
            return .error(error.localizedDescription)
        }
    }

    static func map(_ json: Any?) -> JsonElement {

        guard let json = json else {
            return .error("{empty}")
        }

        switch json {
        case let str as NSString:
            return .string(String(str))
        case let num as NSNumber:
            let encoding = String(cString: num.objCType)
            if encoding == "d" {
                return .num(Double(truncating: num))
            }
            if encoding == "c" {
                return .flag(Bool(exactly: num)!)
            }
            return .int(Int(truncating: num))
        case let dic as NSDictionary:
            return .nested(dic.reduce(into: [:]) { (result, arg) in
                guard let key = arg.key as? String else { return }
                result[key] = JsonElement.map(arg.value)
            })
        case let list as NSArray:
            return .list(list.map { map($0) })
        case is NSNull:
            return .null
        default:
            return .error("\(json)")
        }
    }

    var isValue: Bool {
        switch self {
        case .string(_):
            return true
        case .int(_):
            return true
        case .num(_):
            return true
        case .null:
            return true
        default:
            return false
        }
    }

    var isEmpty: Bool {
        switch self {
        case .list(let items):
            return items.isEmpty
        case .nested(let dic):
            return dic.isEmpty
        default:
            return false
        }
    }
}

struct DebugJsonView_Previews: PreviewProvider {
    static var previews: some View {
        DebugJsonView("\"OK\"")
            .previewLayout(.sizeThatFits)
        DebugJsonView("===")
            .previewLayout(.sizeThatFits)
        DebugJsonView("{ \"name\": \"value\"}")
            .previewLayout(.sizeThatFits)
        DebugJsonView("{ \"user\": { \"name\": \"nia\" } }")
            .previewLayout(.sizeThatFits)
        DebugJsonView("{ \"user\": { \"name\": \"nia\", \"age\": 16 } }")
            .previewLayout(.sizeThatFits)
        DebugJsonView("{ \"comments\": [ { \"name\": \"nia\", \"body\": \"Good Comment\" } ] }")
            .previewLayout(.sizeThatFits)
    }
}


