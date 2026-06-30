function nextUrl() {
  return window.API_NEXT_URL || "/api/animes/next";
}

function ratingsUrl() {
  return window.API_RATINGS_URL || "/api/ratings";
}

async function apiGetNext(genre) {
  const res = await fetch(`${nextUrl()}?genre=${encodeURIComponent(genre)}`, {
    headers: { "Accept": "application/json" }
  });

  if (!res.ok) {
    const txt = await res.text();
    throw new Error(`GET next failed: ${res.status} ${txt}`);
  }

  return await res.json();
}

async function apiSaveRating(animeId, score) {
  const res = await fetch(ratingsUrl(), {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": window.CSRF_TOKEN,
      "Accept": "application/json"
    },
    body: JSON.stringify({ anime_id: animeId, score })
  });

  if (!res.ok) {
    const txt = await res.text();
    throw new Error(`POST rating failed: ${res.status} ${txt}`);
  }

  return await res.json();
}

function favToggleUrl() {
  return window.API_FAVORITES_TOGGLE_URL || "/api/favorites/toggle";
}

async function apiToggleFavorite(animeId) {
  const res = await fetch(favToggleUrl(), {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": window.CSRF_TOKEN,
      "Accept": "application/json"
    },
    body: JSON.stringify({ anime_id: animeId })
  });

  if (!res.ok) {
    const txt = await res.text();
    throw new Error(`POST favorite toggle failed: ${res.status} ${txt}`);
  }
  return await res.json();
}

function formatMeta(genre, avg, my) {
  const label = (window.I18N_META || "Genre: %{theme} | Avg: %{avg} | My rating: %{my}");
  const th = themeTitle(genre);

  return label
    .replace("%{theme}", th)
    .replace("%{avg}", avg)
    .replace("%{my}", my);
}


function themeTitle(genre) {
  const dict = window.I18N_THEMES || {};
  return dict[genre] || genre;
}


document.addEventListener("DOMContentLoaded", () => {
  const themeSelect = document.getElementById("themeSelect");
  const nextBtn = document.getElementById("nextBtn");
  const skipBtn = document.getElementById("skipBtn");
  const status = document.getElementById("status");
  const themeChips = document.getElementById("themeChips");

  function setActiveChip() {
    if (!themeChips || !themeSelect) return;
    const current = themeSelect.value || "random";
    themeChips.querySelectorAll(".chip").forEach((b) => {
      b.classList.toggle("is-active", b.dataset.theme === current);
    });
  }

  themeChips?.addEventListener("click", (e) => {
    const btn = e.target.closest(".chip");
    if (!btn || !themeSelect) return;

    const th = btn.dataset.theme || "random";
    themeSelect.value = th;
    setActiveChip();
  });

  setActiveChip();

  const dishCard = document.getElementById("dishCard");
  const dishTitle = document.getElementById("dishTitle");
  const dishImage = document.getElementById("dishImage");
  const dishMeta = document.getElementById("dishMeta");
  const ratingInfo = document.getElementById("ratingInfo");

  const themeBadge = document.getElementById("themeBadge");
  const avgKpi = document.getElementById("avgKpi");
  const myKpi = document.getElementById("myKpi");

  const favBtn = document.getElementById("favBtn");
  let currentIsFavorite = false;

favBtn?.addEventListener("click", async () => {
  if (!currentDishId) return;
  try {
    const result = await apiToggleFavorite(currentDishId);
    if (result.ok) {
      currentIsFavorite = !!result.favorited;
      favBtn.classList.toggle("is-on", currentIsFavorite);
    }
  } catch (e) {
    console.error(e);
  }
});

  let currentDishId = null;

  async function loadNext() {
    status.textContent = window.I18N_LOADING || "Loading...";
    ratingInfo.textContent = "";

    try {
      const genre = themeSelect ? themeSelect.value : "";
      const data = await apiGetNext(genre);

      if (!data.anime) {
        dishCard.style.display = "none";
        status.textContent = data.message || (window.I18N_NO_DISH || "No anime");
        return;
      }

      currentDishId = data.anime.id;
      dishTitle.textContent = data.anime.title;
      dishImage.src = data.anime.image_url;

      const avg = data.anime.average_rating ?? "—";
      const my = data.my_rating ?? "—";

      currentIsFavorite = !!data.anime.is_favorite;
      favBtn?.classList.toggle("is-on", currentIsFavorite);

      const th = themeTitle(data.anime.genre);

    dishMeta.textContent = formatMeta(data.anime.genre, avg, my);
    if (themeBadge) themeBadge.textContent = `#${th}`;

    if (avgKpi) avgKpi.textContent = `${window.I18N_AVG_LABEL || "Avg"}: ${avg}`;
    if (myKpi) myKpi.textContent = `${window.I18N_MY_LABEL || "My rating"}: ${my}`;


      dishCard.style.display = "block";
      status.textContent = "";
    } catch (e) {
      console.error(e);
      status.textContent = (window.I18N_API_JS_ERROR || "API/JS error (see console)");
      dishCard.style.display = "none";
    }
  }

  nextBtn?.addEventListener("click", loadNext);
  skipBtn?.addEventListener("click", loadNext);

  document.querySelectorAll(".rate-btn").forEach((btn) => {
    btn.addEventListener("click", async () => {
      if (!currentDishId) return;

      try {
        const score = Number(btn.dataset.score);
        const result = await apiSaveRating(currentDishId, score);

        if (result.ok) {
          ratingInfo.textContent = `${window.I18N_SAVED || "Saved"}: ${result.score}`;
          setTimeout(loadNext, 250);
        } else {
          ratingInfo.textContent = (window.I18N_ERROR || "Error");
        }
      } catch (e) {
        console.error(e);
        ratingInfo.textContent = (window.I18N_ERROR || "Error");
      }
    });
  });
});
