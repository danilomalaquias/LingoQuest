# LingoQuest — MVP Android

Protótipo funcional de aprendizado de inglês por aventuras, desenvolvido em Flutter.

## O que já funciona
- Tela inicial com missão do dia, XP e sequência de estudos.
- Seis mundos de aprendizagem com progressão visual.
- Primeira aventura jogável: cumprimentos e apresentações.
- Questões de múltipla escolha com feedback imediato.
- XP, estrelas e progresso salvos localmente no dispositivo.
- Pronúncia em áudio via Text-to-Speech do Android.
- Desafio rápido de revisão.
- Interface em português, com conteúdo de inglês para iniciantes.

> O MVP usa conteúdo estruturado e funciona sem backend. O áudio depende da disponibilidade de uma voz em inglês instalada no Android. A sincronização em nuvem, login, reconhecimento de fala e conversação com IA ficam para etapas futuras.

## Como abrir e executar
1. Instale Flutter (canal stable) e Android Studio/Android SDK.
2. Na raiz do projeto, execute:
   ```bash
   flutter pub get
   flutter run
   ```
3. Para gerar o APK local:
   ```bash
   flutter build apk --release
   ```
   Arquivo gerado: `build/app/outputs/flutter-apk/app-release.apk`

## Compilar pelo GitHub Actions
1. Crie um repositório no GitHub.
2. Envie **todo o conteúdo deste ZIP** para a raiz do repositório (incluindo a pasta oculta `.github`).
3. Acesse a aba **Actions**. O workflow `Build Android APK` será executado automaticamente ao enviar para `main`/`master`.
4. Também é possível executar manualmente em **Actions → Build Android APK → Run workflow**.
5. Ao terminar, abra a execução e baixe o artefato **lingoquest-android-release** na seção Artifacts.

O workflow executa `flutter pub get`, formatação, análise estática, build release e publica o APK como artefato por 14 dias.

## Observações
- O APK é gerado sem assinatura de publicação (adequado para instalação de testes; o Android pode solicitar autorização para instalar apps de fontes desconhecidas).
- Para publicar na Google Play, será necessário configurar uma chave de assinatura (`.jks`) e os segredos correspondentes no GitHub. Nunca envie a chave privada ao repositório.
- O primeiro build pode demorar alguns minutos enquanto o GitHub Actions baixa o SDK e as dependências.
