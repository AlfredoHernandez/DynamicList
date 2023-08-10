//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct TopicSegmentedView: View {
    @Binding var topicSelected: String
    let topics: [String]?

    var body: some View {
        if let topics, !topics.isEmpty {
            Picker(DynamicListPresenter.topics, selection: $topicSelected) {
                ForEach(topics, id: \.self) { topic in
                    Text(topic)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

#if DEBUG
struct TopicSegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        TopicSegmentedView(
            topicSelected: .constant("Today"),
            topics: ["Today", "Sports", "Weather", "Stocks"]
        )
    }
}
#endif
