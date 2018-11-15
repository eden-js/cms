<block-view-stat>
  <div class="card mb-3 bg-{ opts.data.color || 'primary' }">

    <div class="card-header">

      <i if={ !(opts.data.title || '').length }>Untitled { opts.data.name }</i>
      { opts.data.title }
      
    </div>

    <a class="card-body text-white" href={ opts.data.href }>
      <div class="row">
        <div class="col-6">
          <h3>
            { opts.data.total }
          </h3>
          { opts.data.titles.total }
        </div>
        <div class="col-6 text-right">
          <h3>
            { opts.data.today }
          </h3>
          { opts.data.titles.today }
        </div>
      </div>

      <div class="chart-wrapper" ref="chart">
        <chart type="line" class="d-block" data={ this.data.line } options={ this.options.line } size={ this.size } if={ this.eden.frontend && this.size.width } style={ this.size } />
      </div>

    </a>
  </div>

  <script>
    // do mixins
    this.mixin ('i18n');

    // set variables
    this.size     = {};
    this.loading  = {};
    this.updating = {};

    // set options
    this.options = {
      'line' : {
        'maintainAspectRatio' : false,
        'legend' : {
          'display' : false
        },
        'scales' : {
          'xAxes' : [
            {
              'points'  : false,
              'display' : false,
            }
          ],
          'yAxes' : [
            {
              'display' : false,
            }
          ]
        },
        'elements' : {
          'point' : {
            'radius' : 0
          }
        }
      }
    };

    // create days
    let days  = [];
    let start = new Date ();
        start.setHours(24,0,0,0);
        start.setDate(start.getDate() - 14);

    // set current
    let current = new Date(start);

    // loop for deposits
    while (current <= new Date()) {
      // set next
      let next = new Date(current);
          next.setDate(next.getDate() + 1);

      // add date
      days.push(current.toLocaleDateString('en-GB', {
        'day'   : 'numeric',
        'month' : 'short',
        'year'  : 'numeric'
      }));

      // set next
      current = next;
    }

    // set values
    this.data = {
      'line' : {
        'labels'   : days,
        'datasets' : [
          {
            'data'            : opts.data.totals,
            'borderColor'     : 'rgba(255,255,255,.55)',
            'borderWidth'     : 2,
            'backgroundColor' : 'transparent',
          },
        ]
      },
      'bar' : {
        'labels'   : days,
        'datasets' : [
          {
            'data'            : opts.data.values,
            'backgroundColor' : 'rgba(0,0,0,.2)',
          },
        ]
      }
    };

    /**
     * on refresh
     *
     * @param  {Event} e
     */
    async onRefresh (e) {
      // set refreshing
      this.refreshing = true;

      // update view
      this.update();

      // run opts
      if (opts.onRefresh) await opts.onRefresh(opts.block, opts.data);

      // set refreshing
      this.refreshing = false;

      // update view
      this.update();
    }

    /**
     * on mounted
     *
     * @type {Object}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set size
      if (jQuery(this.refs.chart).width()) this.size = {
        'width'  : jQuery(this.refs.chart).width() + 'px',
        'height' : (jQuery(this.refs.chart).width() / 4) + 'px'
      };

      // update
      this.update();
    });
  </script>
</block-view-stat>
