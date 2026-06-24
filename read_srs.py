import requests
import PyPDF2
import io
import sys

def main():
    url = 'https://drive.google.com/uc?export=download&id=1Xotp2fIBzb5QWmg-Fh0sp8Up_4poca48'
    try:
        response = requests.get(url)
        response.raise_for_status()
        pdf_file = io.BytesIO(response.content)
        reader = PyPDF2.PdfReader(pdf_file)
        text = ""
        for page in reader.pages:
            text += page.extract_text() + "\n"
        with open("srs_text.txt", "w", encoding="utf-8") as f:
            f.write(text)
        print("Success")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
