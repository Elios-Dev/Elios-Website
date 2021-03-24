import Foundation
import Publish
import Plot

// This type acts as the configuration for your website.
struct EliosDevGithubIo: Website {
    enum SectionID: String, WebsiteSectionID {
        // Add the sections that you want your website to contain here:
        case articles
        case apps
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        // Add any site-specific metadata that you want to use here.
    }

    // Update these properties to configure your website:
    var url = URL(string: "https://www.elios.ie")!
    var name = "Elios Software Solutions"
    var description = "Elios Software Solutions is an iOS and Swift Consultancy"
    var language: Language { .english }
    var imagePath: Path? { nil }
}

// This will generate your website using the built-in Foundation theme:
try EliosDevGithubIo()
    .publish(using: [
        .generateHTML(withTheme: .foundation),
        .deploy(using: .gitHub("elios-dev/elios-dev.github.io", useSSH: true))
    ])
