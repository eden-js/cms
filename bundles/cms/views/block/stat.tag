<block-stat>
  <div class="card bg-{ opts.data.color || 'primary' }"}>

    <div class="card-header">
      <div class="row row-eq-height">
        <div class="col-8 d-flex align-items-center">
          <div class="w-100">

            <!-- update buttons -->
            <a href="#!" onclick={ onShouldUpdateTitle } if={ !this.updating.title && !this.loading.title }>
              <i class="fa fa-update fa-pencil" />
            </a>
            <a href="#!" onclick={ onCompleteUpdateTitle } if={ this.updating.title && !this.loading.title }>
              <i class="fa fa-update fa-check bg-success text-white" />
            </a>
            <span if={ this.loading.title }>
              <i class="fa fa-update fa-spinner fa-spin bg-info text-white" />
            </span>
            <!-- / update buttons -->

            <i if={ !opts.data.title && !this.updating.title }>Untitled { opts.data.name }</i>
            <span if={ !this.updating.title || this.loading.title }>{ opts.data.title }</span>
            <i contenteditable={ this.updating.title } if={ this.updating.title && !this.loading.title } class="d-inline-block px-2" ref="name" onkeyup={ onUpdateTitle }>{ opts.data.title }</i>

          </div>
        </div>
        <div class="col-4 d-flex align-items-center">
          <div class="w-100">
            <div class="btn-group float-right">
              <yield from="buttons" />
              <button class="btn btn-sm btn-primary" onclick={ onRefresh }>
                <i class={ 'fa fa-sync' : true, 'fa-spin' : this.refreshing || opts.block.refreshing } />
              </button>
              <button class="btn btn-sm btn-info" data-toggle="modal" data-target="#block-{ opts.block.uuid }-update">
                <i class="fa fa-pencil" />
              </button>
              <button class="btn btn-sm btn-danger" onclick={ onRemove }>
                <i class={ 'fa fa-times' : true, 'fa-spin' : this.removing || opts.block.removing } />
              </button>
              <span class="btn btn-sm btn-secondary move">
                <i class="fa fa-arrows" />
              </span>
            </div>
          </div>
        </div>
      </div>
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

  <div class="modal fade" id="block-{ opts.block.uuid }-update" tabindex="-1" role="dialog" aria-labelledby="block-{ opts.block.uuid }-label" aria-hidden="true">
    <div class="modal-dialog" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="exampleModalLabel">
            Update Block
          </h5>
          <button type="button" class="close" data-dismiss="modal" aria-label="Close">
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div class="modal-body">
          <div class="form-group">
            <label>
              Block Class
            </label>
            <input class="form-control" ref="class" value={ opts.data.class } onchange={ onClass } />
          </div>
          <div class="form-group">
            <label>
              Block Color
            </label>
            <input class="form-control" ref="color" value={ opts.data.color } onchange={ onColor } />
          </div>
          <yield from="modal" />
        </div>
      </div>
    </div>
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
     * on update name
     *
     * @param  {Event} e
     */
    onUpdateTitle (e) {
      // on enter
      let keycode = (event.keyCode ? event.keyCode : event.which);

      // check if enter
      if (parseInt(keycode) === 13) {
        // return on complete update
        return this.onCompleteUpdateTitle(e);
      }

      // set update
      opts.data.title = jQuery(e.target).val();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    async onCompleteUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.loading.title = true;
      this.updating.title = false;

      // set name
      opts.data.title = jQuery('[ref="name"]', this.root).text();

      // update
      this.update();

      // do update
      await opts.onSave(opts.block, opts.data);

      // set loading
      this.loading.title = false;

      // update
      this.update();
    }

    /**
     * on update name
     *
     * @param  {Event} e
     */
    onShouldUpdateTitle (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();

      // set update
      this.updating.title = !this.updating.title;

      // update
      this.update();

      // set inner test
      jQuery('[ref="name"]', this.root).focus();
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
</block-stat>
