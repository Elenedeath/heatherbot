from flask import Flask, request, send_file
import torchaudio as ta
import tempfile
from chatterbox.tts_turbo import ChatterboxTurboTTS

app = Flask(__name__)
model = ChatterboxTurboTTS.from_pretrained(device="cuda")

@app.route("/health", methods=["GET"])
def health():
    return {"status": "healthy", "model": "chatterbox-turbo"}

@app.route("/tts", methods=["POST"])
def tts():
    data = request.get_json()
    text = data.get("text", "")
    wav = model.generate(text)

    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as f:
        tmp_path = f.name

    ta.save(tmp_path, wav, model.sr)
    return send_file(tmp_path, mimetype="audio/wav", as_attachment=False)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)