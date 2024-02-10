#include <QGuiApplication>
#include <QObject>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQuickItem>
#include <QQuickView>
#include <QTranslator>

class TranslationTest : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString language READ language NOTIFY languageChanged)

public:
    TranslationTest(QQuickView *view) : m_view(view)
    {
        QLocale locale;

        m_language = QLocale::languageToCode(locale.language());

        loadLanguage(locale);
    }

    QString language() { return m_language; }

    Q_INVOKABLE void selectLanguage(QString language)
    {
        if (language == m_language)
            return;

        m_language = language;

        QCoreApplication::removeTranslator(&m_translator);

        loadLanguage(QLocale(language));

        m_view->engine()->retranslate();

        emit languageChanged();
    }

signals:
    void languageChanged();

private:
    void loadLanguage(const QLocale &locale)
    {
        if (m_translator.load(locale, QLatin1String("locale"), QLatin1String("_")))
            qDebug() << "Language" << locale.language() << "loaded.";
        else
            qDebug() << "Couldn't load language.";

        QCoreApplication::installTranslator(&m_translator);
    }

    QTranslator m_translator;
    QString m_language;
    QQuickView *m_view;
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQuickView view;

    TranslationTest translationTest(&view);

    const QUrl url(u"qrc:/Demo75060420/main.qml"_qs);
    QObject::connect(view.engine(), &QQmlEngine::quit, &view, &QWindow::close);
    view.setTitle(QStringLiteral("QML Translate"));
    view.rootContext()->setContextProperty("translationTest", (QObject *) &translationTest);
    view.setSource(url);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.show();

    return app.exec();
}

#include "main.moc"
