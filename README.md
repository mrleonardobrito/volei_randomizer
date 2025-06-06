# Volei Randomizer 🏐

Um aplicativo Flutter para gerenciamento e organização de times de vôlei, facilitando a criação de partidas e o acompanhamento de jogadores.

## Funcionalidades 🎯

- **Gerenciamento de Jogadores**

  - Cadastro individual de jogadores
  - Inserção em massa de jogadores através de lista numerada
  - Classificação por tipo de jogador

- **Gerenciamento de Times**

  - Criação automática de times balanceados
  - Distribuição equilibrada de jogadores
  - Prevenção de times jogando contra si mesmos

- **Gerenciamento de Partidas**
  - Criação de partidas entre times
  - Sistema de rotação de times
  - Acompanhamento de resultados

## Pré-requisitos 📋

- Flutter SDK
- Android Studio / VS Code
- Java Development Kit (JDK) 17
- Android SDK

## Instalação 🚀

1. Clone o repositório:

```bash
git clone [URL_DO_REPOSITÓRIO]
cd volei_randomizer
```

2. Instale as dependências:

```bash
flutter pub get
```

3. Execute o aplicativo:

```bash
flutter run
```

## Gerando APK 📱

Para gerar um APK de release:

```bash
flutter build apk
```

O APK será gerado em: `build/app/outputs/flutter-apk/app-release.apk`

## Estrutura do Projeto 🏗️

```
lib/
├── models/
│   ├── player.dart
│   ├── team.dart
│   └── match.dart
├── services/
│   └── volleyball_service.dart
└── screens/
    ├── home_screen.dart
    ├── players_screen.dart
    ├── teams_screen.dart
    └── matches_screen.dart
```

## Contribuindo 🤝

1. Faça um Fork do projeto
2. Crie uma Branch para sua Feature (`git checkout -b feature/AmazingFeature`)
3. Faça o Commit de suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Faça o Push para a Branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request
