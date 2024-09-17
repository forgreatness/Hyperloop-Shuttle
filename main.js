const CLIENT_ID = "b067d5cb828ec5a";
const IMGUR_API_ORIGIN = "https://api.imgur.com/3/gallery/search";
const ACCEPTED_MEDIA_TYPE = ['jpeg', 'jpg', 'png'];

async function getQueryImages(query) {
    const url = `${IMGUR_API_ORIGIN}/?q=${encodeURIComponent(query)}`;

    try {
        loadingSpinner.style.display = 'block';

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
    } finally {
        loadingSpinner.style.display = 'none';
    }
}

// Step 1: get the element which you need to attach a listener to
let exploreButton = document.getElementById('exploreButton');
let exploreInput = document.getElementById('searchQueryInput');
let carousel = document.querySelector('.carousel');
let indicators = document.getElementsByClassName('carousel-indicators').item(0);
let loadingSpinner = document.getElementById('loadingSpinner');
let currentImages = [];
let currentActiveIndex;

if (exploreButton) {
    exploreButton.addEventListener('click', async function onExploreClick(e) {
        let exploreQuery = exploreInput?.value ?? "";

        if (exploreQuery) {
            let images = await getQueryImages(exploreQuery);
            images = getAllValidImage(images);
            currentImages = images;
            currentActiveIndex = currentImages.length < 2 ? 0 : 1;

            displayImages(currentImages);
        }
    });
}

function getAllValidImage(images = []) {
    if (!images || images.length < 1) return;

    const filteredImages = images.filter(function (image) {
        let imageSrc = image?.images?.[0]?.link ?? "";

        if (imageSrc && ACCEPTED_MEDIA_TYPE.includes(String(imageSrc).split('.').pop())) return true;
    });

    return filteredImages;
}

// Modify the function to display only 5 images centered around the current center index
function displayImages(images) {
    carousel.innerHTML = ''; // Clear previous results
    let start, end;

    if (currentActiveIndex === currentImages.length - 1) {
        start = Math.max(currentActiveIndex - 2, 0);
        end = currentActiveIndex + 1;
    } else {
        start = Math.max(currentActiveIndex - 1, 0);
        end = Math.min(start + 3, currentImages.length);
    }

    const visibleImages = images.slice(start, end);

    visibleImages.forEach((image, index) => {
        console.log("what is the image content, ", image);
        const item = document.createElement('div');
        item.classList.add('carousel-item');
        if (index === currentActiveIndex) item.classList.add('active'); // Middle image is active

        const img = document.createElement('img');
        img.src = image.images[0].link;
        img.loading = 'lazy';
        img.alt = image.images[0]?.description || 'Image';

        img.addEventListener('click', function() {
            Swal.fire({
                title: image?.title ?? "Untitled",
                text: image.images[0]?.description || 'No description available',
                imageUrl: this.src,
                imageWidth: 800,
                imageAlt: 'Image',
                confirmButtonText: 'Close'
            });
        });

        const description = document.createElement('div');
        description.classList.add('description');
        description.textContent = image.images[0]?.description || 'No description available';

        item.appendChild(img);
        item.appendChild(description);
        carousel.appendChild(item);
    });

    createIndicators(visibleImages.length);
}

// Modify the indicators function to handle re-centering / or update indicator if it already exist
function createIndicators(count) {
    if (!indicators) {
        indicators = document.createElement('div');
        indicators.classList.add('carousel-indicators');
        indicators.innerHTML = '';
    }

    // Clear the indicators content for now until we figure out how to replace it efficiently
    indicators.innerHTML = "";
    let start, end;

    if (currentActiveIndex === currentImages.length-1) {
        start = Math.max(currentActiveIndex - (count - 1), 0);
        end = Math.min(start + count, currentImages.length);
    } else {
        start = Math.max(currentActiveIndex - 1, 0);
        end = Math.min(start + count, currentImages.length);
    }

    // Create indicators for the currently visible 5 images
    for (let i = start; i < end; i++) {
        const button = document.createElement('button');
        if (i === currentActiveIndex) button.classList.add('active');
        
        button.addEventListener('click', () => {
            if (currentActiveIndex === i) return;

            currentActiveIndex = i; // Update the center to the clicked index
            displayImages(currentImages); // Re-display the images with the new center
        });

        indicators.appendChild(button);
    }

    carousel.parentNode.append(indicators);
}

