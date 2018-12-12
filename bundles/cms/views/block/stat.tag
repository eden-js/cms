<block-stat>
  <block on-refresh={ opts.onRefresh } chart={ this.chart } options={ this.options } on-save={ opts.onSave } on-remove={ opts.onRemove } size={ this.size } block={ opts.block } data={ opts.data } on-color={ onColor } ref="block" class="block-stat">

    <yield to="modal">
      <div class="form-group">
        <label>
          Block Color
        </label>
        <input class="form-control" ref="color" value={ opts.data.color } onchange={ opts.onColor } />
      </div>
    </yield>

    <yield to="body">
      <div class="card mb-3 bg-{ opts.data.color || 'primary' }">
    
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
            <chart type="line" class="d-block" data={ opts.chart.line } options={ opts.options.line } size={ opts.size } if={ this.eden.frontend && opts.size.width } style={ opts.size } />
          </div>
    
        </a>
      </div>
    </yield>

  </block>

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
    this.chart = {
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
     * on class

     * @param  {Event} e
     */
    async onClass (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.data.class = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }

    /**
     * on class

     * @param  {Event} e
     */
    async onColor (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set class
      opts.data.color = e.target.value.length ? e.target.value : null;

      // run opts
      if (opts.onSave) await opts.onSave(opts.block, opts.data);
    }

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
     * on refresh
     *
     * @param  {Event} e
     */
    async onRemove (e) {
      // set refreshing
      this.removing = true;

      // update view
      this.update();

      // run opts
      if (opts.onRemove) await opts.onRemove(opts.block, opts.data);

      // set refreshing
      this.removing = false;

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
      if (jQuery(this.refs.block.refs.chart).width()) this.size = {
        'width'  : jQuery(this.refs.block.refs.chart).width() + 'px',
        'height' : (jQuery(this.refs.block.refs.chart).width() / 4) + 'px'
      };

      // update
      this.update();
    });
  </script>
</block-stat>
