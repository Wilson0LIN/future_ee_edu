# EE-Visuals

> **打造電機工程的未來教育基石！用精美的互動式動畫，讓電機學習變得直觀、有趣且順暢。**

這是一個專為**電機工程**教育設計的開源概念專案。我們深信，複雜的公式與抽象的電磁波、訊號處理，不應該只存在於課本的幾何線條中。本專案旨在利用 **Flutter** 強大的渲染能力，製作出如同知名數學科普頻道 **3Blue1Brown** 般精美、流暢且具備互動性的視覺化動畫，幫助所有走在電機之路上的學習者輕鬆跨越理解難關。

目前本專案僅由此作為開端，釋出核心的架構與初步構想。期待未來有人能把這個概念實現！

---

## 🚀 核心願景

- 🎨 **極致視覺**：揮別枯燥的二維圖表，追求動態、優雅且符合物理直覺的動畫呈現。
- 🕹️ **互動學習**：使用者不僅是看動畫，還能透過拉桿、點擊實時改變參數（如頻率、相位、磁場強度），觀察隨之而來的物理變化。
- 🤝 **社群驅動**：不論你是電機專家、Flutter 開發者，還是對科學動畫充滿熱情的愛好者，這裡都是你的舞台。

## 🛠️ 開發與運行指引

本專案目前**未進行任何封裝與打包**。若要瀏覽或測試功能，請直接下載原始碼並在本地端透過 Flutter 運行。

### 前置準備
在開始之前，請確保你的電腦已安裝 Flutter 開發環境：
- [Flutter SDK 安裝指南](https://flutter.dev)
- Dart 程式語言基礎

### 本地運行步驟

1. **複製專案倉庫（Clone Repository）**
   ```bash
   git clone https://github.com
   cd 你的專案名稱
   ```

2. **安裝依賴套件**
   ```bash
   flutter pub get
   ```

3. **啟動專案**
   請確保已連接模擬器或實體裝置（或使用 Web/Desktop 模式），然後執行：
   ```bash
   flutter run
   ```

---

## 🗺️ 願景藍圖 (Roadmap)

我們期望未來能逐步涵蓋以下電機核心領域的視覺化：
- [ ] **電磁學 (Electromagnetics)**：麥克斯韋方程組、電場與磁場的動態傳播、波導管。
- [ ] **電路學 (Circuit Theory)**：交流電（AC）相量圖動態變化、RLC 電路暫態響應。
- [ ] **訊號與系統 (Signals and Systems)**：傅立葉轉換（Fourier Transform）的幾何幾何拆解、卷積（Convolution）的動態過程。
- [ ] **電力電子 (Power Electronics)**：逆變器與整流器的電流流向切換視覺化。
- [ ] **控制系統 (Control Systems)**：波德圖（Bode Plot）、根軌跡的動態拉動。

---

## 🤝 如何參與貢獻？ (Contributing)

這個專案的未來取決於開源社群的力量！如果你想加入我們，可以透過以下方式參與：

1. **提交 Issue**：若發現 Bug、數學公式錯誤，或是想提出新的動畫點子，歡迎隨時開 Issue 討論。
2. **提交 Pull Request (PR)**：
   - Fork 本專案。
   - 建立你的功能分支 (`git checkout -b feature/AmazingVisualization`)。
   - 撰寫你的 Dart/Flutter 程式碼，並在本地測試。
   - 提交你的修改 (`git commit -m 'Add some amazing visualization'`)。
   - 推送到分支 (`git push origin feature/AmazingVisualization`)。
   - 提交 Pull Request。

### 我們需要的才華：
- **電機/物理專家**：協助驗證數學模型與物理現象的正確性。
- **Flutter 開發者**：優化 Canvas 繪圖效能、設計流暢的 UI/UX 與動畫。
- **教育工作者**：提供教學痛點，告訴我們哪些概念最需要被「視覺化」。

> *"If you want to learn something, read about it. If you want to understand something, write about it. If you want to master something, teach it."* 
> 讓我們一起為電機教育打造一盞明燈！💡
