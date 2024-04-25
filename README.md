# notion_to_anki

A small tool so you can export your Notion pages to deck descriptions in Anki. Write and collaborate on Anki deck descriptions without needing to use html.

## Use-Case

### What problem does this tool solve?

Notion can export its pages as html files. Unfortunately these files aren't fully compatible with Anki so they look bad and loose some features. This tool adapts Notion's html files to fix this.

### Limitations

1. Background colors of blocks are lost. Mark the whole text instead or use callouts.
2. To include images some manual work is needed.

## Usage

### 1) Export Notion Pages

- Click on the three dots in the top-right corner and select "Export".
- Apply the following settings:
  - `Export format`: `HTML`
  - `Include content`: `Everything`
  - `Include subpages`:`yes`
  - `Create folders for subpages`: `no`
- Click "Export" and download the ".zip" file
- Unzip this file

> TIP: If you want to export and convert multiple files at once, structure your descriptions in a table.

### 2) Convert Files

- Open this tool
- Select the files you want to use from the folder you downloaded
- If your page contains images, set the `Anki Image Paths` (more information below)
- Click "Convert"

Now you can copy the descriptions directly to Anki or use the newly created '.converted.html' files.

### 3) Anki

- Copy the page you want by clicking "Copy"
- Open Anki and navigate to the deck you want to edit.
- Click on "Description" in the bottom of the window.
- Paste and make sure "Anki 2.1.41+ handling" is unchecked.
- Click "OK".

### Images

*Problem*: If your Notion page contains images, you need to include them manually in your deck.

You can do this by placing these files in the [Anki folder](https://docs.ankiweb.net/files.html). If you use a sync-service like Ankihub, you probably should include a card in your deck that uses these images so they will be synchronized.

If the filenames in Notion and Anki do not match you either have to rename the files in the Anki folder or you set new names and paths in the `Anki Image Paths` field relative to the Anki folder one path per line.

## Contributing

Feel free to open an issue or pull request for any reason.
