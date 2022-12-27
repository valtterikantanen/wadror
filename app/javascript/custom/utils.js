const BEERS = {};
const BREWERIES = {};

const handleResponseBeers = beers => {
  BEERS.list = beers;
  BEERS.show();
};

const handleResponseBreweries = breweries => {
  BREWERIES.list = breweries;
  BREWERIES.show();
};

const createTableRow = columns => {
  const tr = document.createElement("tr");
  tr.classList.add("tablerow");
  columns.forEach(column => appendChildToTableRow(tr, column));
  return tr;
};

const appendChildToTableRow = (tablerow, content) => {
  const td = tablerow.appendChild(document.createElement("td"));
  td.innerHTML = content;
};

const removeTableRows = () => {
  document.querySelectorAll(".tablerow").forEach(el => el.remove());
};

BEERS.show = () => {
  removeTableRows();
  const table = document.getElementById("beertable");

  BEERS.list.forEach(beer => {
    const columns = [beer.name, beer.style.name, beer.brewery.name];
    const tr = createTableRow(columns);
    table.appendChild(tr);
  });
};

BREWERIES.show = () => {
  removeTableRows();
  const table = document.getElementById("brewerytable");

  BREWERIES.list.forEach(brewery => {
    const columns = [brewery.name, brewery.year, brewery.beers.amount, brewery.active ? "Active" : "Retired"];
    const tr = createTableRow(columns);
    table.appendChild(tr);
  });
};

const sortByName = arr => arr.sort((a, b) => a.name.toUpperCase().localeCompare(b.name.toUpperCase()));

BEERS.sortByName = () => sortByName(BEERS.list);

BREWERIES.sortByName = () => sortByName(BREWERIES.list);

BEERS.sortByStyle = () => {
  BEERS.list.sort((a, b) => a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase()));
};

BEERS.sortByBrewery = () => {
  BEERS.list.sort((a, b) => a.brewery.name.toUpperCase().localeCompare(b.brewery.name.toUpperCase()));
};

BREWERIES.sortByYear = () => BREWERIES.list.sort((a, b) => a.year - b.year);

BREWERIES.sortByAmountOfBeers = () => BREWERIES.list.sort((a, b) => a.beers.amount - b.beers.amount);

async function getData(filename) {
  const response = await fetch(filename);
  const data = await response.json();
  if (filename === "beers.json") {
    handleResponseBeers(data);
  } else if (filename === "breweries.json") {
    handleResponseBreweries(data);
  }
}

const beers = () => {
  if (document.querySelectorAll("#beertable").length < 1) return;

  getData("beers.json");

  const callbacks = new Map([
    ["name", BEERS.sortByName],
    ["style", BEERS.sortByStyle],
    ["brewery", BEERS.sortByBrewery]
  ]);

  const clickableElements = ["name", "style", "brewery"];

  clickableElements.forEach(element => {
    document.getElementById(element).addEventListener("click", () => {
      callbacks.get(element)();
      BEERS.show();
    });
  });
};

const breweries = () => {
  if (document.querySelectorAll("#brewerytable").length < 1) return;

  getData("breweries.json");

  const callbacks = new Map([
    ["name", BREWERIES.sortByName],
    ["year", BREWERIES.sortByYear],
    ["amount-of-beers", BREWERIES.sortByAmountOfBeers]
  ]);

  const clickableElements = ["name", "year", "amount-of-beers"];

  clickableElements.forEach(element => {
    document.getElementById(element).addEventListener("click", () => {
      callbacks.get(element)();
      BREWERIES.show();
    });
  });
};

export { beers, breweries };
