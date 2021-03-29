//
//  File.swift
//
//
//  Created by Niall Quinn on 24/03/2021.
//

import Publish
import Plot

public extension Theme {
    static var elios: Self {
        Theme(
            htmlFactory: EliosHTMLFactory(),
            resourcePaths: ["Resources/EliosTheme/styles.css"]
        )
    }
}

private struct EliosHTMLFactory<Site: Website>: HTMLFactory {
    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: index, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .contentBody(index.body)
                ),
                .footer(for: context.site)
            )
        )
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        
        func bodyContent() -> Node<HTML.BodyContext> {
            if section.items.isEmpty {
                return
                    .wrapper(
                        Node.contentBody(section.body)
                    )
            } else {
                return
                    .wrapper(
                        .h1(.text(section.title)),
                        Node.itemList(for: section.items, on: context.site)
                    )
            }
        }
        
        return HTML(
            .lang(context.site.language),
            .head(for: section, on: context.site),
            .body(
                .header(for: context, selectedSection: section.id),
                bodyContent(),
                .footer(for: context.site)
            )
        )
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        HTML(
            .lang(context.site.language),
            .head(for: item, on: context.site),
            .body(
                .class("item-page"),
                .header(for: context, selectedSection: item.sectionID),
                .wrapper(
                    .article(
                        .div(
                            .class("content"),
                            .contentBody(item.body)
                        ),
                        .span("Tagged with: "),
                        .tagList(for: item, on: context.site)
                    )
                ),
                .footer(for: context.site)
            )
        )
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(for: context.index, context: context)
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        nil
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        HTML(
            .lang(context.site.language),
            .head(for: page, on: context.site),
            .body(
                .header(for: context, selectedSection: nil),
                .wrapper(
                    .h1(
                        "Tagged with ",
                        .span(.class("tag"), .text(page.tag.string))
                    ),
                    .a(
                        .class("browse-all"),
                        .text("Browse all tags"),
                        .href(context.site.tagListPath)
                    ),
                    .itemList(
                        for: context.items(
                            taggedWith: page.tag,
                            sortedBy: \.date,
                            order: .descending
                        ),
                        on: context.site
                    )
                ),
                .footer(for: context.site)
            )
        )
    }
}

private extension Node where Context == HTML.BodyContext {
    static func wrapper(_ nodes: Node...) -> Node {
        .div(.class("wrapper"), .group(nodes))
    }

    static func header<T: Website>(
        for context: PublishingContext<T>,
        selectedSection: T.SectionID?
    ) -> Node {
        let sectionIDs = T.SectionID.allCases

        return .header(
            .wrapper(
                .img(.class("header-image"), .src("/images/elios-logo.png"), .alt(context.site.name)),
                .p(.text(context.site.description)),
                .if(sectionIDs.count > 1,
                    .nav(
                        .ul(
                          .li(.class(selectedSection == nil ? "selected" : ""),
                            .a(.href("/"),
                                .text("Home")
                            )),
                          .forEach(sectionIDs) { section in
                            .li(.class(section == selectedSection ? "selected" : ""),
                              .a(.href(context.sections[section].path),
                                .text(context.sections[section].title)
                            ))
                        })
                    )
                )
            )
        )
    }
    
    static func contactForm() -> Node {
        .wrapper(
            .class("form-wapper"),
            .div(
                .class("form-area"),
                .div(
                    .class("img-area")
                ),
                .div(
                    .class("right-text"),
                    .form(
                        .attribute(named: "netlify"),
                        .input(.name("Name"), .type(.text), .placeholder("Enter Your Name")),
                        .input(.name("Email"), .type(.email), .placeholder("Enter Your Email")),
                        .textarea(.name(""), .cols(30), .rows(10), .id("")),
                        .input(.type(.submit), .name("Submit"))
                    )
                )
            )
        )
    }

    static func itemList<T: Website>(for items: [Item<T>], on site: T) -> Node {
        return .ul(
            .class("item-list"),
            .forEach(items) { item in
                .li(.article(
                    .h1(.a(
                        .href(item.path),
                        .text(item.title)
                    )),
                    .tagList(for: item, on: site),
                    .p(.text(item.description))
                ))
            }
        )
    }

    static func tagList<T: Website>(for item: Item<T>, on site: T) -> Node {
        return .ul(.class("tag-list"), .forEach(item.tags) { tag in
            .li(.a(
                .href(site.path(for: tag)),
                .text(tag.string)
            ))
        })
    }

    static func footer<T: Website>(for site: T) -> Node {
        return .footer(
            .wrapper(
                .h1("Get in touch"),
                .contactForm()
            ),
            .p(
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .p(.a(
                .text("RSS feed"),
                .href("/feed.rss")
            ))
        )
    }
}
