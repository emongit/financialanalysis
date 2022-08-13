//
//  ContentView.swift
//  financialanalysis
//
import SwiftUI
import CoreData

struct FirstPage: View {
    let items = ["任天堂（500039395）", "ソニー（981245683）", "トヨタ（400094643）", "ユニクロ（770004185）"]

    var body: some View {
        NavigationView {
            List {
                ForEach(0 ..< items.count) { index in
                    NavigationLink(destination: DetailView()) {
                        Text(items[index])
                    }
                }
            }
            .navigationBarTitle("")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct SecondPage: View {
    
        let items : [String] = ["任天堂（500039395）", "ソニー（981245683）", "トヨタ（400094643）", "ユニクロ（770004185）", "A株式会社（1111111）", "Bカンパニー（2222222）", "C.com（3333333）", "ユニDDD（4444444）", "DDD（555555）","E社（66666666）","eee（7777777）","Eカンパニー（88888888）","eスポーツ協会（9999999）","ee-ne!!（00000000）"]
            
        @State var isEditing = false
        @State var searchText = ""
        
        var filterdItems: [String] {
                if searchText.isEmpty {
                    return items
                } else {
                    return items.filter {$0.uppercased().contains(searchText.uppercased())}
                }
            }
        var body: some View {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                    })
                    if isEditing {
                        Button(action: {
                            self.searchText = ""
                        }){
                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .padding()
                
                List {
                    ForEach(filterdItems, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
}

struct ThirdPage: View {
        @State private var items = ["任天堂（500039395）", "ソニー（981245683）", "トヨタ（400094643）", "ユニクロ（770004185）"]
     
        var body: some View {
            NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    NavigationLink(destination: DetailView()) {
                    Text(item)
                    }
                }
                .onDelete(perform: rowRemove)
                .onMove(perform: rowReplace)
            }
            .navigationBarTitle("")
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                EditButton()
            }
            }
        }

        func rowRemove(offsets: IndexSet) {
            items.remove(atOffsets: offsets)
        }
    
        func rowReplace(_ from: IndexSet, _ to: Int) {
            items.move(fromOffsets: from, toOffset: to)
        }
}

struct FourthPage: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        entity: Memo.entity(),
        sortDescriptors: [NSSortDescriptor(key: "updatedAt", ascending: false)],
        animation: .default
    ) var fetchedMemoList: FetchedResults<Memo>

    var body: some View {
        NavigationView {
            List {
                ForEach(fetchedMemoList) { memo in
                    NavigationLink(destination: EditMemoView(memo: memo)) {
                        VStack {
                            Text(memo.title ?? "")
                               .font(.title)
                               .frame(maxWidth: .infinity,alignment: .leading)
                               .lineLimit(1)
                           HStack {
                               Text (memo.stringUpdatedAt)
                                   .font(.caption)
                                   .lineLimit(1)
                               Text(memo.content ?? "")
                                   .font(.caption)
                                   .lineLimit(1)
                               Spacer()
                           }
                        }
                    }
                }
                .onDelete(perform: deleteMemo)
            }
            .navigationTitle("メモ")
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddMemoView()) {
                        Text("新規作成")
                       
                    }
                }
            }
        }
    }
    
    private func deleteMemo(offsets: IndexSet) {
        offsets.forEach { index in
            viewContext.delete(fetchedMemoList[index])
        }
        try? viewContext.save()
    }
}

struct DetailView: View {
    @State var selectedIndex = 0

    var body: some View {
        
        Text("企業名（企業コード）")
        
        Picker("", selection: $selectedIndex) {
            Text("BS")
                .tag(0)
            Text("PL")
                .tag(1)
            Text("CF")
                .tag(2)
        }.pickerStyle(SegmentedPickerStyle())
        Text("ここにシートを表示")
        
        Spacer()
    }
}

struct ContentView: View {

    var body: some View {
        TabView{
            FirstPage()
                .tabItem {
                    Image(systemName: "house")
                    Text("ホーム")
                }
            SecondPage()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("検索")
                }
            ThirdPage()
                .tabItem {
                    Image(systemName: "star")
                    Text("お気に入り")
                }
            FourthPage()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("メモ")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
