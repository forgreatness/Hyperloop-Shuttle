const CLIENT_ID = "b067d5cb828ec5a";
const IMGUR_API_ORIGIN = "https://api.imgur.com/3/gallery/search";

async function getQueryImages(query) {
    const url = `${IMGUR_API_ORIGIN}/?q=${encodeURIComponent(query)}`;

    try {
        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'Authorization': `Client-ID ${CLIENT_ID}`
            }
        });

        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }

        const data = await response.json();
        return data.data;
    } catch (e) {
        console.log("There was an issue with retrieving images, ", e);
        throw e;
    }
}

document.getElementById('searchButton').addEventListener('click', async () => {
    const query = document.getElementById('searchQueryInput').value;
    const images = await getQueryImages(query);
    displayImages(images);
});

function displayImages(images) {
    const carousel = document.querySelector('.carousel');
    carousel.innerHTML = ''; // Clear previous results

    images.slice(0, 5).forEach((image, index) => {
        const item = document.createElement('div');
        item.classList.add('carousel-item');
        if (index === 0) item.classList.add('active');

        const img = document.createElement('img');
        img.src = image.link;
        item.appendChild(img);

        carousel.appendChild(item);
    });

    createIndicators(images.length);
}

function createIndicators(count) {
    const indicators = document.createElement('div');
    indicators.classList.add('carousel-indicators');

    for (let i = 0; i < Math.min(count, 5); i++) {
        const button = document.createElement('button');
        if (i === 0) button.classList.add('active');
        button.addEventListener('click', () => {
            document.querySelectorAll('.carousel-item').forEach((item, index) => {
                item.style.transform = `translateX(-${i * 100}%)`;
                document.querySelectorAll('.carousel-indicators button')[index].classList.toggle('active', index === i);
            });
        });
        indicators.appendChild(button);
    }

    document.querySelector('.carousel').appendChild(indicators);
}
