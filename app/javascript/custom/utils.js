const BEERS = {};
const BREWERIES = {};

const handleResponseBeers = (beers) => {
  BEERS.list = beers;
  BEERS.show();
};

const handleResponseBreweries = (breweries) => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = (columns) => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");

  columns.forEach((column) => {
    appendChildToTableRow(tr, column);
  });

  return tr;
}

const appendChildToTableRow = (tablerow, content) => {
  const td = tablerow.appendChild(document.createElement("td"));
  td.innerHTML = content;
};

const removeTableRows = () => {
  document.querySelectorAll(".tablerow").forEach((el) => el.remove());
}

BEERS.show = () => {
  removeTableRows();
  const table = document.getElementById("beertable");

  BEERS.list.forEach((beer) => {
    const columns = [beer.name, beer.style.name, beer.brewery.name];
    const tr = createTableRow(columns);
    table.appendChild(tr);
  });
};

BREWERIES.show = () => {
  removeTableRows();
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach((brewery) => {
    const columns = [brewery.name, brewery.year, brewery.beers.amount, brewery.active ? "Active" : "Retired"];
    const tr = createTableRow(columns);
    table.appendChild(tr);
  });
};

BEERS.sortByName = () => {
  BEERS.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BEERS.sortByStyle = () => {
  BEERS.list.sort((a, b) => {
    return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
  });
};

BEERS.sortByBrewery = () => {
  BEERS.list.sort((a, b) => {
    return a.brewery.name
      .toUpperCase()
      .localeCompare(b.brewery.name.toUpperCase());
  });
};

BREWERIES.sortByName = () => {
  BREWERIES.list.sort((a, b) => {
    return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
  });
};

BREWERIES.sortByYear = () => {
  BREWERIES.list.sort((a, b) => {
    return a.year - b.year;
  });
};

BREWERIES.sortByAmountOfBeers = () => {
  BREWERIES.list.sort((a, b) => {
    return a.beers.amount - b.beers.amount;
  });
};

const beers = () => {
  if (document.querySelectorAll("#beertable").length < 1) return;

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByName();
    BEERS.show();
  });

  document.getElementById("style").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByStyle();
    BEERS.show();
  });

  document.getElementById("brewery").addEventListener("click", (e) => {
    e.preventDefault();
    BEERS.sortByBrewery();
    BEERS.show();
  });

  fetch("beers.json")
    .then((response) => response.json())
    .then(handleResponseBeers);
};

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;

  document.getElementById("name").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByName();
    BREWERIES.show();
  });

  document.getElementById("year").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByYear();
    BREWERIES.show();
  });

  document.getElementById("amount-of-beers").addEventListener("click", (e) => {
    e.preventDefault();
    BREWERIES.sortByAmountOfBeers();
    BREWERIES.show();
  });

  fetch("breweries.json")
    .then((response) => response.json())
    .then(handleResponseBreweries);
};

export { beers, breweries };
