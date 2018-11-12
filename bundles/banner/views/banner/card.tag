<prize-card>
  <div class={ 'card' : true, 'border-success' : opts.active } onclick={ onSelect }>
    <div class="card-body" if={ opts.prize.image }>
      <media-img image={ opts.prize.image } label="sm-sq" classes="img-fluid rounded" />
    </div>
    <div class={ 'card-footer' : true, 'border-success' : opts.active }>
      { opts.prize.name }
    </div>
  </div>

  <script>

    /**
     * on click
     *
     * @param  {Event} e
     *
     * @return {Fn}
     */
    onSelect (e) {
      // on click function
      if (opts.onselect) opts.onselect (opts.prize);
    }
  </script>
</prize-card>
