# SAP ABAP MCP Shopfloor Dashboard Tools API Dokumentation

Diese Dokumentation beschreibt die verfügbaren Funktionen (Tools) zur Steuerung und Simulation von Ereignissen auf dem Shopfloor Dashboard über die SAP ABAP MCP Server Schnittstelle.

## 1. `set_shopfloor_led_color`

**Funktion:** Setzt die Farbe einer Shopfloor LED, um den aktuellen Status des Systems visuell zu signalisieren.

**Parameter:**
| Parameter | Typ | Beschreibung | Muss | Enum-Werte |
| :--- | :--- | :--- | :--- | :--- |
| `color` | String | Die gewünschte Farbe für die LED. | Ja | `grey`, `red`, `green`, `yellow` |
| `context` | String | Optionaler Kontext oder Grund für die Farbanpassung (z.B. Begründung). | Nein | - |

**Erklärung der Werte:**
*   `red`: "Full stop for everything" (Absolutes Stoppsignal)
*   `green`: "The shopfloor is in normal state" (Normaler Betriebszustand)
*   `yellow`: "The shopfloor is in maintenance mode" (Wartungsmodus)
*   `grey`: "The shopfloor is inactive" (Inaktiver Zustand)

**Anwendungsbeispiel:**

**Ziel:** Den Status auf Normalbetrieb setzen.
```json
{
  "tool_name": "set_shopfloor_led_color",
  "parameters": {
    "color": "green",
    "context": "Normaler Produktionsfluss erkannt."
  }
}
```

## 2. `set_shopfloor_message`

**Funktion:** Setzt eine Nachricht, die zentral auf dem Shopfloor Dashboard angezeigt wird.

**Parameter:**
| Parameter | Typ | Beschreibung | Muss |
| :--- | :--- | :--- | :--- |
| `message` | String | Der eigentliche Text der Nachricht. | Ja |
| `author` | String | Optionaler Verweis auf den Autor der Nachricht. | Nein |

**Anwendungsbeispiel:**

**Ziel:** Eine wichtige Systemmeldung mit einem Autor anzeigen.
```json
{
  "tool_name": "set_shopfloor_message",
  "parameters": {
    "message": "Wichtige Wartung erforderlich für Linie 3.",
    "author": "MaintenanceTeam"
  }
}
```

## 3. `set_shopfloor_progress`

**Funktion:** Setzt den Fortschrittswert (als Prozent) für eine zentrale Anzeige auf dem Dashboard.

**Parameter:**
| Parameter | Typ | Beschreibung | Muss |
| :--- | :--- | :--- | :--- |
| `progress` | Integer | Der Fortschrittswert in Prozent. | Ja |

**Einschränkungen:**
Der Wert muss eine ganze Zahl zwischen **0 und 120** liegen.

**Anwendungsbeispiel:**

**Ziel:** Den Prozessfortschritt auf 75% setzen.
```json
{
  "tool_name": "set_shopfloor_progress",
  "parameters": {
    "progress": 75
  }
}
```

## 4. `simulate_process`

**Funktion:** Simuliert die Ausführung eines Produktionsprozesses mit einer spezifischen Bearbeitungszeit. Die Simulation erfolgt sequenziell und wartet auf Abschluss der vorherigen Schritte (falls erforderlich).

**Parameter:**
| Parameter | Typ | Beschreibung | Muss |
| :--- | :--- | :--- | :--- |
| `seconds` | Integer | Die Dauer der zu simulierenden Arbeit in Sekunden. | Ja |

**Anwendungsbeispiel:**

**Ziel:** Simulation eines Prozesses, der 15 Sekunden dauert.
```json
{
  "tool_name": "simulate_process",
  "parameters": {
    "seconds": 15
  }
}
```

## 5. `get_weight`

**Funktion:** Ruft den simulierten aktuellen Wert der Shopfloor-Waage ab.

**Parameter:**
| Parameter | Typ | Beschreibung | Muss |
| :--- | :--- | :--- | :--- |
| *(Keine)* | - | Keine Parameter erforderlich. | Nein |

**Anwendungsbeispiel:**

**Ziel:** Aktuellen simulierten Gewichtswert abrufen.
```json
{
  "tool_name": "get_weight",
  "parameters": {}
}
```