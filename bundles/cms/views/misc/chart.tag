<chart>
  <canvas class="chart chart-{ opts.type }" ref="chart" />

  <script>
    // set c to false
    this.built = false;

    /**
     * draw chart function
     */
    drawChart () {
      // set c
      if (this.build) this.build.destroy();

      // set width/height
      jQuery(this.refs.chart).attr('width', (opts.size || {}).width);
      jQuery(this.refs.chart).attr('height', (opts.size || {}).height);

      // set chart
      let ctx = this.refs.chart.getContext('2d');
      
      // require chart
      const Chart = require('chart.js');

      // set chart
      this.build = new Chart(ctx, {
        'type'    : opts.type,
        'data'    : opts.data,
        'options' : opts.options
      });
    }

    /**
     * should update
     *
     * @param  {*} data
     *
     * @return {Boolean}
     */
    shouldUpdate (data) {
      // check jQuery
      if (!this.built) return true;

      // return built
      return false;
    }

    /**
     * on chart function
     *
     * @type {Event} e
     */
    this.on('chart', (e) => {
      // draw chart
      if (opts.type && opts.data && opts.size && opts.size.width) this.drawChart();
    });

    /**
     * on mount function
     *
     * @param  {String} 'mount'
     */
    this.on('mount', () => {
      // check jQuery
      if (!this.eden.frontend) return;

      // draw chart
      this.trigger('chart');
    });

    /**
     * on mount function
     *
     * @param  {String} 'mount'
     */
    this.on('update', () => {
      // check jQuery
      if (!this.eden.frontend) return;

      // draw chart
      this.trigger('chart');
    });
  </script>
</chart>
