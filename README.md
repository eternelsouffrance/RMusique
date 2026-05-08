# 🎵 RMusique

RMusique est un outil Windows développé en **PowerShell** permettant d’installer, gérer et personnaliser facilement votre expérience musicale.

## ✨ Fonctionnalités

- Installation automatique de RMusique
- Détection automatique de l’architecture système :
  - x64
  - ARM64
  - x32
- Mise à jour automatique vers la dernière version
- Ajout automatique dans le PATH Windows
- Migration des anciennes versions
- Installation simple via script `.ps1`

---

## 📦 Installation

### 1. Cloner le projet

```bash
git clone https://github.com/VOTRE-USERNAME/RMusique.git
```

### 2. Ouvrir PowerShell

Lancer **PowerShell** sur Windows.

### 3. Autoriser les scripts (si nécessaire)

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. Lancer l’installation

```powershell
.\install.ps1
```

---

## 🚀 Utilisation

Une fois installé :

```powershell
RMusique -h
```

---

## 📂 Structure du projet

```plaintext
RMusique/
│
├── install.ps1
├── README.md
└── releases/
```

---

## 🔧 Prérequis

- Windows 10/11
- :contentReference[oaicite:0]{index=0} 5.1 ou supérieur
- Connexion internet

---

## 📜 Licence

Projet sous licence MIT.

---

## 👨‍💻 Développeur

Créé par **eternelsouffrance**
