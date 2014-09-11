var makeGraph;
makeGraph = function() {
  //Width and height
  var w = 1000;
  var h = 600;
  var padding = 100;

  var dataset = [];
  var xValues = [];
  var names = [];




  //Create scale functions
  var xScale = d3.scale.ordinal()
             .domain(xValues)
             .rangePoints([100,1000],1);

  var yScale = d3.scale.linear()
             .domain([30, 45])
             .range([h - padding, padding]);

  var rScale = d3.scale.linear()
             .domain([0, d3.max(dataset, function(d) { return d[1]; })])
             .range([2, 5]);

  //Define X axis
  var xAxis = d3.svg.axis()
            .scale(xScale)
            .orient("bottom")
            .ticks(5);

  //Define Y axis
  var yAxis = d3.svg.axis()
            .scale(yScale)
            .orient("left")
            .ticks(5);

  //Create SVG element
  var svg = d3.select("body")
        .append("svg")
        .attr("width", w)
        .attr("height", h);

  //Create circles
  svg.selectAll("circle")
     .data(dataset)
     .enter()
     .append("circle")
     .attr("cx", function(d) {
         return xScale(d[0]);
     })
     .attr("cy", function(d) {
         return yScale(d[1]);
     })
     .attr("r", function(d) {
         return rScale(d[1]);
     });

  //Create labels
  svg.selectAll("text")
     .data(dataset)
     .enter()
     .append("text")
     .text(function(d) {
         return Math.round(d[1]) + " minutes";
     })
     .attr("x", function(d) {
         return xScale(d[0]);
     })
     .attr("y", function(d) {
         return yScale(d[1]);
     })
     .attr("font-family", "sans-serif")
     .attr("font-size", "11px")
     .attr("fill", "red")
     .attr("class","datapoint")
     .attr("id",function(d) {
        return Math.round(d[0]);
    });


  //Create X axis
  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0," + (h - padding) + ")")
    .call(xAxis);

  //Create Y axis
  svg.append("g")
    .attr("class", "axis")
    .attr("transform", "translate(" + padding + ",0)")
    .call(yAxis);
  }
