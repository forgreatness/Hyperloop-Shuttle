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
        return data;
    } catch (e) {
        console.log("There was an issue with retrieving images, ", e);
        throw e;
    }
}

getQueryImages('cats').then(data => {
    const carouselInner = document.getElementById('carousel-inner');
    const carouselIndicators = document.getElementById('carousel-indicators');

    data.data.forEach((item, index) => {
        if (item?.images?.[0] && !item.images[0].link.endsWith('.mp4')) {
            // Create a carousel item
            const carouselItem = document.createElement('div');
            carouselItem.classList.add('carousel-item');
            if (index === 0) carouselItem.classList.add('active'); // Ensure only the first item is active

            // Create an image element
            const img = document.createElement('img');
            img.src = item.images[0].link;
            img.classList.add('d-block', 'w-100');
            img.alt = item.title;

            // Append the image to the carousel item
            carouselItem.appendChild(img);
            carouselInner.appendChild(carouselItem);

            // Create a carousel indicator
            const indicator = document.createElement('button');
            indicator.type = 'button';
            indicator.dataset.bsTarget = '#imgurCarousel';
            indicator.dataset.bsSlideTo = index;
            if (index === 0) indicator.classList.add('active');
            indicator.ariaCurrent = index === 0 ? 'true' : '';
            indicator.ariaLabel = `Slide ${index + 1}`;

            // Append the indicator to the carousel-indicators
            carouselIndicators.appendChild(indicator);
        }
    });
}).catch(error => {
    console.error('Error:', error);
});
