//
//  Copyright © 2023 Jesús Alfredo Hernández Alarcón. All rights reserved.
//

import SwiftUI

struct TopicSegmentedView: View {
    @Binding var topicSelected: String
    let topics: [String]

    var body: some View {
        if !topics.isEmpty {
            Picker("Topics", selection: $topicSelected) {
                ForEach(topics, id: \.self) { topic in
                    Text(topic)
                }
            }
            .pickerStyle(.segmented)
            .padding()
        }
    }
}

struct TopicSegmentedView_Previews: PreviewProvider {
    static var previews: some View {
        TopicSegmentedView(
            topicSelected: .constant("Today"),
            topics: ["Today", "Sports", "Weather", "Stocks"]
        )
    }
}
