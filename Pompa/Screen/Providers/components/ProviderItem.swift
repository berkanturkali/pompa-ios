import SwiftUI
import WebKit

struct ProviderItem: View {
    let provider: Provider
    let isSelected: Bool
    let onItemClick: () -> Void

    var body: some View {
        Button(action: onItemClick) {
            HStack(spacing: 12) {
                HStack(spacing: 10) {
                    ProviderLogoView(logoPath: provider.logo)

                    Text(provider.name.titleCased)
                        .font(PompaTypography.font(size: 17, weight: .semibold))
                        .foregroundStyle(PompaColors.Text.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.trailing, 8)
                    .foregroundStyle(Color(red: 0.30, green: 0.69, blue: 0.31))
                    .opacity(isSelected ? 1 : 0)
                    .scaleEffect(isSelected ? 1 : 0.7)
                    .animation(.spring(response: 0.24, dampingFraction: 0.84), value: isSelected)
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .padding(.horizontal, 12)
            .background(PompaColors.Card.primaryBackground.opacity(0.95))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(PompaColors.border, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.10), radius: 5, y: 2)
        }
        .buttonStyle(.plain)
    }
}

struct ProviderLogoView: View {
    let logoPath: String?

    var body: some View {
        ZStack {
            Circle()
                .fill(PompaColors.Card.primaryBackground)
                .overlay(
                    Circle()
                        .stroke(PompaColors.border.opacity(0.8), lineWidth: 0.5)
                )

            if let logoURL {
                if logoURL.pathExtension.lowercased() == "svg" {
                    RemoteSVGImage(url: logoURL)
                        .frame(width: 28, height: 28)
                        .clipShape(Circle())
                } else {
                    AsyncImage(url: logoURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        default:
                            fallbackIcon
                        }
                    }
                }
            } else {
                fallbackIcon
            }
        }
        .frame(width: 40, height: 40)
        .clipShape(Circle())
    }

    private var logoURL: URL? {
        guard let logoPath, !logoPath.isEmpty else { return nil }

        if let absoluteURL = URL(string: logoPath), absoluteURL.scheme != nil {
            return normalizedAbsoluteURL(absoluteURL)
        }

        let normalizedPath = logoPath.hasPrefix("/") ? String(logoPath.dropFirst()) : logoPath
        return ApiConfig.imageBaseURL.appendingPathComponent(normalizedPath)
    }

    private func normalizedAbsoluteURL(_ url: URL) -> URL {
        guard let host = url.host?.lowercased(),
              host == "localhost" || host == "127.0.0.1" || host == "10.0.2.2",
              let baseComponents = URLComponents(url: ApiConfig.imageBaseURL, resolvingAgainstBaseURL: false),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }

        components.scheme = baseComponents.scheme
        components.host = baseComponents.host
        components.port = baseComponents.port

        return components.url ?? url
    }

    private var fallbackIcon: some View {
        Image(systemName: "drop.fill")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(PompaColors.Text.primary)
    }
}

private struct RemoteSVGImage: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.backgroundColor = .clear
        webView.isUserInteractionEnabled = false
        webView.layer.cornerRadius = 17
        webView.layer.masksToBounds = true
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
        <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background: transparent;
            overflow: hidden;
        }
        img {
            width: 100%;
            height: 100%;
            object-fit: contain;
            border-radius: 50%;
        }
        </style>
        </head>
        <body>
            <img src="\(url.absoluteString)" />
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: url.deletingLastPathComponent())
    }
}

#Preview {
    ZStack {
        PompaColors.Background.primary
            .ignoresSafeArea()

        ProviderItem(
            provider: Provider(id: 1, name: "opet", logo: nil, isManual: false),
            isSelected: true,
            onItemClick: {}
        )
        .padding(16)
    }
}
