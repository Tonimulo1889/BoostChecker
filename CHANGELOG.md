# Changelog - Boost Roleplay PC-Checker Suite

Alle Änderungen, Fehlerbehebungen und System-Upgrades im Überblick.

---

## [5.0.0] - 20.09.2026

### 🚨 Live Cheater & Bann-Board (Kanal 1551244953911566418)
* **Interaktives Cheater-Board:**
  * Auto-Purge: Der Kanal wird vor jedem Update automatisch bereinigt – keine doppelten oder veralteten Nachrichten mehr.
  * Zeigt die neuesten überführten Cheater inklusive Name, PC, erkannter Cheats und Datum in Echtzeit an.
  * **Discord Modal Suche:** Klick auf `[🔍 Spieler suchen]` öffnet ein natives Discord-Eingabefenster. Prüft sekundenschnell, ob ein Spieler (Name, SteamID, FiveM-Lizenz oder Discord-ID) als Cheater registriert oder sauber ist.
  * **Blätter-Funktion:** Über `[📋 Liste durchblättern]` können alle archivierten Fälle seitenweise (5 Fälle pro Seite) mit `[⬅️ Vorherige]` und `[➡️ Nächste]` durchgesehen werden.

### 🏆 Team-Statistiken & Supporter-Leaderboard
* **Neuer Slash-Command `/teamstats` (sowie `!teamstats`):**
  * Wertet die Aktivität aller Teammitglieder aus (Gesamt-Checks, überführte Cheater, saubere Checks, letzter aktiver Check).
  * Sortiertes Leaderboard mit Medaillen (🥇, 🥈, 🥉) für transparente Teamauswertung.

### 🔄 24/7 Hosting & Always-On Autostart
* **Automatischer Watchdog (`Tools/Start-24-7-Bot.bat`):**
  * Startet den Bot bei einem unerwarteten Absturz oder Verbindungsabbruch innerhalb von 3 Sekunden automatisch neu.
* **Windows Autostart Dienst (`Tools/Install-Windows-Autostart.ps1`):**
  * Richtet den Bot als unsichtbaren 24/7 Hintergrund-Dienst in der Windows-Aufgabenplanung ein. Startet automatisch bei jedem System-Boot.
* **Linux VPS / Root-Server Ready (`Tools/boostbot.service`):**
  * Vorgefertigte systemd-Service-Datei für 24/7 Hosting auf Linux / FiveM Hostern (Zap, Hetzner etc.).

---

## [4.5.0] - 20.09.2026

### 🛡️ Discord Bot & Slash-Commands
* **Neuer Slash-Command `/check <Ziel> [Grund]`:**
  * Durchsucht alle archivierten Beweisakten in unter 0,2 Sekunden.
  * Unterstützt die Suche nach Discord-ID (`11346359...`), Discord-Mention (`@User`), Steam64 (`7656119...`), FiveM-Lizenz (`license:...`) und Spieler-/PC-Name.
  * Erkennt verknüpfte Zweit-Accounts (**Steam-Alts**, Rockstar-Profile und verbundene Discord-Konten) desselben Computers.
  * Enthält einen **`[⚡ txAdmin Quick-Ban]`** Button zum direkten Kopieren des fertigen Bann-Befehls inklusive aller gesammelten Lizenzen.
  * Ermöglicht mit **`[🚨 Verweigerung melden]`** das sofortige Protokollieren eines Verweigerungs-Banns in der Google-Tabelle.
* **Team-Rollen-Schutz:**
  * Mitglieder mit der Rollen-ID `1550863432352403537` sind vollständig geschützt.
  * Versuche, Teammitglieder zu überprüfen, werden serverseitig abgewiesen (`Aktion verweigert`).
* **Interaktions-Latenz (Fehler 10062 behoben):**
  * Discord-Buttons und Slash-Commands antworten nun in unter 30 Millisekunden.
  * Externe Anfragen (Google Sheets, Dateizugriffe) wurden strikt in asynchrone Hintergrund-Threads (`asyncio.to_thread`) ausgelagert.

### 📊 Google Sheets Live-Protokoll (v3.2)
* **Anti-Duplikate & Single-Row Lifecycle:**
  * Pro PC-Check existiert genau **eine einzige Zeile** von Anfang bis Ende.
  * Der Code-Start erstellt die Zeile, die Support-Annahme aktualisiert sie (Admin-Name & Status) und der Scan-Abschluss trägt das Urteil sowie den Dossier-Namen ein.
  * Einsatz von `LockService.getScriptLock()` mit 15-Sekunden-Queue verhindert Race-Conditions bei zeitgleichen Webhook-Aufrufen.
  * Automatische Deduplizierung entfernt historische Mehrfacheinträge desselben PINs.
* **Spalten-Struktur bereinigt (8 Kernspalten):**
  * `Datum & Uhrzeit`, `Spieler (Account)`, `PC-Name`, `Auth-PIN`, `Ergebnis (Urteil)`, `Status`, `Pruefender Admin`, `HTML-Beweisakte`.
  * Spielername und PC-Name sind sauber getrennt (kein Zusammenschieben mehr).
  * Hardware-ID und Cheats-Spalten wurden entfernt, da diese Details vollständig in der HTML-Beweisakte dokumentiert sind.

### 📈 `#stats` Live-Dashboard
* **Auto-Purge System:**
  * Der Bot bereinigt den `#stats`-Kanal (`channel.purge`) vor dem Senden eines neuen Dashboards.
  * Es gibt im Kanal immer exakt **eine** persistente, aktuelle Dashboard-Nachricht anstelle endlos gestapelter Bot-Nachrichten.
* **Echte Server-Statistiken:**
  * Zählt live alle Checks auf dem Server (Gesamt, Sauber, Warnungen, Cheater).
  * Aktualisiert sich vollautomatisch, sobald im `#checked-users`-Kanal ein neuer Bericht eingeht, sowie über den `[🔄 Aktualisieren]`-Button.

### 🎨 Design & Visuals
* **Entfernung übergroßer Banner:**
  * Die riesigen 16:9 Bannerbilder, die den Chat blockiert haben, wurden aus allen Embeds entfernt.
  * Alle Status-Embeds nutzen jetzt ein kompaktes, hochauflösendes 3D **B-Shield Wappen** als diskretes Thumbnail im oberen rechten Eck.
* **Text-Bereinigung:**
  * Doppelte PIN-Anzeigen, überflüssige Hilfstexte und lange Konsolen-Anweisungen wurden aus den Embeds entfernt.

### ⚙️ Client & Core-Engine
* **Geschützte RAM-Ausführung:**
  * Sämtliche 25 Scanning-Module werden per AES-256 verschlüsselt im `Core/BoostCore.pkg` gebündelt und beim Start direkt im RAM entschlüsselt.
  * Keine temporären `.ps1`-Dateien auf der Festplatte des Spielers.
* **Encoding-Harmonisierung:**
  * Alle Client-Skripte wurden auf UTF-8 mit BOM normiert, um Parsing-Fehler auf unterschiedlichen Windows-Sprachversionen (DE/EN/FR) auszuschließen.
