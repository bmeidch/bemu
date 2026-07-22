const twitch = require("twitch-m3u8");
const fs = require("fs");

const CHANNEL = "pijartv";
const OUTPUT = "pijartv.m3u";

async function main() {
  try {
    console.log(`Mengambil stream Twitch: ${CHANNEL}`);

    const streams = await twitch.getStream(CHANNEL);

    if (!streams || streams.length === 0) {
      throw new Error("Tidak ada stream yang ditemukan.");
    }

    console.log("Kualitas tersedia:");

    streams.forEach((stream, index) => {
      console.log(
        `${index + 1}. ${stream.quality || "Unknown"}`
      );
    });

    // Prioritaskan kualitas source/chunked
    const selected =
      streams.find(s =>
        /source|chunked/i.test(s.quality || "")
      ) || streams[0];

    if (!selected || !selected.url) {
      throw new Error("URL stream tidak ditemukan.");
    }

    console.log(
      `Kualitas dipilih: ${selected.quality}`
    );

    const playlist = `#EXTM3U
#EXTINF:-1 tvg-id="pijartv" tvg-name="Pijar TV" group-title="Indonesia",Pijar TV
${selected.url}
`;

    fs.writeFileSync(
      OUTPUT,
      playlist,
      "utf8"
    );

    console.log(
      `${OUTPUT} berhasil diperbarui.`
    );

  } catch (error) {
    console.error(
      "Gagal memperbarui playlist:"
    );

    console.error(error);

    process.exit(1);
  }
}

main();
